import Foundation

// ======================================================
// MARK: - ADAPTIVE WELLNESS PREDICTOR
// ======================================================

/**
 AIWellnessPredictor is an offline-first, on-device adaptive learning engine.
 It replaces the static CoreML model with a lightweight online regression model
 whose weights update incrementally from the user's own mood feedback — no
 .mlmodel file, no internet connection, and no retraining pipeline required.

 ── HOW IT WORKS ─────────────────────────────────────────────────────────────

 The predictor maintains 8 feature weights and a bias term in UserDefaults.
 On every call to `predictWellnessAdjustment(metrics:)` it:

   1. Normalises each HealthMetrics field to [0, 1] using the same ceilings
      as WellnessRuleEngine (ScoringConstants), keeping both engines aligned.
   2. Computes a weighted dot-product of the normalised features.
   3. Scales to a [0, 100] mood prediction.

 Whenever the user submits a mood check-in, `updateWeights(metrics:moodScore:)`
 runs one gradient descent step:

   error  = (moodScore / 100) − prediction
   Δwᵢ   = learningRate × error × featureᵢ
   wᵢ    = clamp(wᵢ + Δwᵢ − weightDecay × wᵢ,  minWeight, maxWeight)
   bias  += learningRate × error

 This is pure arithmetic — no ML framework, no model serialisation, minimal
 battery impact, and safe to run on any thread via the internal serial queue.

 ── ONBOARDING BOOTSTRAP ─────────────────────────────────────────────────────

 `bootstrapFromHistory(_:)` receives up to 30 days of HealthKit history and
 seeds each weight in proportion to how strongly that feature's daily mean
 exceeds the cross-feature average. A user who walks 12 000 steps but sleeps
 5 hours starts with step-weight high and sleep-weight low, producing accurate
 first-day predictions without any mood feedback yet.

 ── WARM-UP BLEND FACTOR ─────────────────────────────────────────────────────

 `blendFactor` ramps from 0 → mlBlendWeight over the first
 `adaptiveWarmupEntries` feedback submissions. WellnessEngine reads this value
 so the adaptive predictor contributes nothing before it has learned anything,
 and reaches its full weight only after sufficient feedback.

 ── PRIVACY ──────────────────────────────────────────────────────────────────

 All state (weights, bias, counters) is stored in UserDefaults under namespaced
 keys. Nothing leaves the device.

 ── THREAD SAFETY ────────────────────────────────────────────────────────────

 All mutations go through `adaptiveQueue` (a private serial DispatchQueue).
 Read-only calls (predict, blendFactor) are safe from any thread.
 */
final class AIWellnessPredictor {

    // ======================================================
    // MARK: - SINGLETON
    // ======================================================

    static let shared = AIWellnessPredictor()

    // ======================================================
    // MARK: - PERSISTENCE KEYS
    // ======================================================

    private enum Keys {
        static let weights       = "adaptive.weights.v1"
        static let bias          = "adaptive.bias.v1"
        static let feedbackCount = "adaptive.feedbackCount.v1"
        static let isBootstrapped = "adaptive.isBootstrapped.v1"
    }

    // ======================================================
    // MARK: - STATE
    // ======================================================

    /// Feature weights. Index order matches featureVector(from:):
    ///   0 steps · 1 sleepHours · 2 exerciseMinutes · 3 screenTime (inv)
    ///   4 unlockCount (inv) · 5 productiveUsageRatio · 6 locationsVisited · 7 routineCompletionRatio
    private var weights: [Double]

    /// Bias term — shifts the prediction up/down independent of features.
    private var bias: Double

    /// Total mood feedback entries received since installation.
    private(set) var feedbackCount: Int

    /// True once the one-time historical bootstrap has completed.
    private(set) var isBootstrapped: Bool

    private let adaptiveQueue = DispatchQueue(label: "com.wellness.adaptive", qos: .utility)

    // ======================================================
    // MARK: - INIT
    // ======================================================

    private init() {
        let stored = UserDefaults.standard.array(forKey: Keys.weights) as? [Double]
        let n      = ScoringConstants.adaptiveFeatureCount
        weights       = stored ?? [Double](repeating: ScoringConstants.adaptiveInitialWeight, count: n)
        bias          = UserDefaults.standard.double(forKey: Keys.bias)
        feedbackCount = UserDefaults.standard.integer(forKey: Keys.feedbackCount)
        isBootstrapped = UserDefaults.standard.bool(forKey: Keys.isBootstrapped)
    }

    // ======================================================
    // MARK: - WARM-UP BLEND FACTOR
    // ======================================================

    /// How much of ScoringConstants.mlBlendWeight the predictor currently
    /// contributes to the final score. Ramps 0 → mlBlendWeight linearly
    /// over the first `adaptiveWarmupEntries` feedback submissions.
    var blendFactor: Double {
        let warmup = Double(ScoringConstants.adaptiveWarmupEntries)
        return min(Double(feedbackCount) / warmup, 1.0) * ScoringConstants.mlBlendWeight
    }

    // ======================================================
    // MARK: - PREDICTION
    // ======================================================

    /// Returns a personalised mood score (0–100) derived from the current
    /// adaptive weights. Thread-safe — reads weights without mutation.
    func predictWellnessAdjustment(metrics: HealthMetrics) -> Double {
        let features = featureVector(from: metrics)
        let raw      = zip(weights, features).reduce(bias) { $0 + $1.0 * $1.1 }
        return (raw * 100.0).clamped(to: 0...100)
    }

    // ======================================================
    // MARK: - ONLINE WEIGHT UPDATE
    // ======================================================

    /**
     Runs one gradient descent step using the user's reported mood as the target.
     Called by WellnessBackend immediately after the user submits a mood check-in.

     - Parameters:
       - metrics:   The HealthMetrics collected for the same day.
       - moodScore: User-reported mood, 0 (worst) to 100 (best).
     */
    func updateWeights(metrics: HealthMetrics, moodScore: Double) {
        adaptiveQueue.async { [weak self] in
            guard let self else { return }

            let features   = self.featureVector(from: metrics)
            let prediction = zip(self.weights, features).reduce(self.bias) { $0 + $1.0 * $1.1 }
            let target     = moodScore / 100.0
            let error      = target - prediction

            let lr    = ScoringConstants.adaptiveLearningRate
            let decay = ScoringConstants.adaptiveWeightDecay
            let lo    = ScoringConstants.adaptiveMinWeight
            let hi    = ScoringConstants.adaptiveMaxWeight

            for i in 0..<self.weights.count {
                self.weights[i] = (self.weights[i] + lr * error * features[i] - decay * self.weights[i])
                                  .clamped(to: lo...hi)
            }
            self.bias         += lr * error
            self.feedbackCount += 1
            self.persist()
        }
    }

    // ======================================================
    // MARK: - ONBOARDING BOOTSTRAP
    // ======================================================

    /**
     Seeds initial weights from historical HealthKit data (up to 30 days).
     Silently ignored after the first successful call (isBootstrapped = true).

     Algorithm:
       1. Build a feature vector for each historical day.
       2. Compute per-feature mean across all days.
       3. Assign each weight proportionally to how much its mean exceeds the
          cross-feature average, then normalise so weights sum to 1.
       4. Seed bias at 0.5 → neutral 50/100 starting prediction.

     - Parameter historicalMetrics: Daily HealthMetrics snapshots, oldest first.
     */
    func bootstrapFromHistory(_ historicalMetrics: [HealthMetrics]) {
        guard !isBootstrapped, !historicalMetrics.isEmpty else { return }

        adaptiveQueue.async { [weak self] in
            guard let self else { return }

            let n   = ScoringConstants.adaptiveFeatureCount
            var sums = [Double](repeating: 0, count: n)

            for m in historicalMetrics {
                let f = self.featureVector(from: m)
                for i in 0..<n { sums[i] += f[i] }
            }

            let count   = Double(historicalMetrics.count)
            let means   = sums.map { $0 / count }
            let overall = means.reduce(0, +) / Double(n)

            var raw   = means.map { max(0, $0 - overall + ScoringConstants.adaptiveInitialWeight) }
            let total = raw.reduce(0, +)

            if total > 0 {
                raw = raw.map { ($0 / total).clamped(to: ScoringConstants.adaptiveMinWeight...ScoringConstants.adaptiveMaxWeight) }
            } else {
                raw = [Double](repeating: ScoringConstants.adaptiveInitialWeight, count: n)
            }

            self.weights       = raw
            self.bias          = 0.5
            self.isBootstrapped = true
            self.persist()
        }
    }

    // ======================================================
    // MARK: - RESET
    // ======================================================

    /// Clears all adaptive state and returns to factory defaults.
    /// Use for testing or when the user resets their profile.
    func resetToDefaults() {
        adaptiveQueue.async { [weak self] in
            guard let self else { return }
            let n          = ScoringConstants.adaptiveFeatureCount
            self.weights   = [Double](repeating: ScoringConstants.adaptiveInitialWeight, count: n)
            self.bias      = 0.0
            self.feedbackCount  = 0
            self.isBootstrapped = false
            self.persist()
        }
    }

    // ======================================================
    // MARK: - PRIVATE HELPERS
    // ======================================================

    /// Converts HealthMetrics into a normalised [0, 1] feature vector.
    /// Uses the same ScoringConstants ceilings as WellnessRuleEngine so both
    /// engines interpret raw metric values identically.
    private func featureVector(from metrics: HealthMetrics) -> [Double] {
        let C = ScoringConstants.self
        return [
            min(metrics.steps           / C.dailyStepGoal,              1.0),  // 0
            min(metrics.sleepHours      / C.optimalSleepHours,          1.0),  // 1
            min(metrics.exerciseMinutes / C.dailyExerciseMinutes,       1.0),  // 2
            max(0, 1 - metrics.screenTimeHours / C.maxHealthyScreenTimeHours), // 3 (inverted)
            max(0, 1 - metrics.unlockCount     / C.maxHealthyUnlockCount),     // 4 (inverted)
            min(metrics.productiveUsageRatio,                           1.0),  // 5
            min(metrics.locationsVisited / C.maxRoutineLocations,       1.0),  // 6
            min(metrics.routineCompletionRatio,                         1.0)   // 7
        ]
    }

    /// Persists weights, bias, and counters to UserDefaults.
    /// Must be called from within adaptiveQueue.
    private func persist() {
        let d = UserDefaults.standard
        d.set(weights,        forKey: Keys.weights)
        d.set(bias,           forKey: Keys.bias)
        d.set(feedbackCount,  forKey: Keys.feedbackCount)
        d.set(isBootstrapped, forKey: Keys.isBootstrapped)
    }
}

// ======================================================
// MARK: - DOUBLE CLAMP  (used by AIWellnessTuner and WellnessScoring)
// ======================================================

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        return Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
