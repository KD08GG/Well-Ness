import Foundation

// ======================================================
// MARK: - WELLNESS SCORING PROTOCOLS
// ======================================================

/// Computes a full `WellnessBreakdown` from raw `HealthMetrics`.
protocol WellnessScorer {
    func calculateWellness(metrics: HealthMetrics) -> WellnessBreakdown
}

/// Calculates rule-based scores for each wellness category.
protocol RuleBasedScorer {
    func calculatePhysical(_ metrics: HealthMetrics) -> Double
    func calculateMental(_ metrics: HealthMetrics) -> Double
    func calculateMindfulness(_ metrics: HealthMetrics) -> Double
}

/// Provides per-category AI adjustments derived from a CoreML model.
/// Each value is signed and clamped by `ScoringConstants.maxAICategoryAdjustment`.
protocol MLAdjustmentProvider {
    func predictAdjustments(metrics: HealthMetrics) -> MLCategoryAdjustments
}

/// Container for the three per-category AI personalisation nudges.
struct MLCategoryAdjustments {
    let physical: Double
    let mental: Double
    let mindfulness: Double

    static let zero = MLCategoryAdjustments(physical: 0, mental: 0, mindfulness: 0)
}

// ======================================================
// MARK: - RULE-BASED WELLNESS ENGINE
// ======================================================

/// Pure rule-based scorer — no ML dependency.
/// Every threshold and weight comes from `ScoringConstants`.
class WellnessRuleEngine: RuleBasedScorer {

    private func normalize(_ value: Double, max ceiling: Double) -> Double {
        return min(value / ceiling, 1.0) * 100
    }

    private func inverseNormalize(_ value: Double, max ceiling: Double) -> Double {
        return Swift.max(0, 100 - (value / ceiling) * 100)
    }

    func calculatePhysical(_ metrics: HealthMetrics) -> Double {
        let stepScore     = normalize(metrics.steps,           max: ScoringConstants.dailyStepGoal)
        let sleepScore    = normalize(metrics.sleepHours,      max: ScoringConstants.optimalSleepHours)
        let exerciseScore = normalize(metrics.exerciseMinutes, max: ScoringConstants.dailyExerciseMinutes)

        return stepScore     * ScoringConstants.physicalStepWeight +
               sleepScore    * ScoringConstants.physicalSleepWeight +
               exerciseScore * ScoringConstants.physicalExerciseWeight
    }

    func calculateMental(_ metrics: HealthMetrics) -> Double {
        let screenScore = inverseNormalize(metrics.screenTimeHours, max: ScoringConstants.maxHealthyScreenTimeHours)
        let unlockScore = inverseNormalize(metrics.unlockCount,     max: ScoringConstants.maxHealthyUnlockCount)
        let sleepScore  = normalize(metrics.sleepHours,             max: ScoringConstants.optimalSleepHours)

        return screenScore * ScoringConstants.mentalScreenWeight +
               unlockScore * ScoringConstants.mentalUnlockWeight +
               sleepScore  * ScoringConstants.mentalSleepWeight
    }

    func calculateMindfulness(_ metrics: HealthMetrics) -> Double {
        var score: Double = 50

        // ── Apps positivas ──────────────────────────────
        if metrics.educationTime > 1    { score += 20 }
        if metrics.productivityTime > 2 { score += 10 }

        // ── Apps negativas ──────────────────────────────
        if metrics.socialMediaTime > 3  { score -= 20 }
        if metrics.passiveRatio > 0.7   { score -= 20 }
        if metrics.diversityScore < 3   { score -= 10 }

        // ── Aislamiento (proxy via ubicaciones) ─────────
        if metrics.locationsVisited < 2 { score -= 10 }

        return score.clamped(to: 0...100)
    }
}

// ======================================================
// MARK: - ML PERSONALIZATION ENGINE
// ======================================================

/**
 MLPredictionEngine wraps `AIWellnessPredictor` and converts its single mood
 score into three signed per-category adjustments.

 The model predicts a global mood (0–100). The engine interprets the deviation
 from the neutral mid-point (50) as a sentiment signal, then distributes that
 signal across categories in proportion to how much each category needs help —
 ensuring the AI nudge is targeted rather than uniform.

 When you have enough data to retrain the model with three output heads (one
 per category), replace `deriveCategoryAdjustments` with direct reads of those
 outputs and remove this derivation entirely.
 */
class MLPredictionEngine: MLAdjustmentProvider {

    private let predictor = AIWellnessPredictor.shared
    private let rules     = WellnessRuleEngine()

    func predictAdjustments(metrics: HealthMetrics) -> MLCategoryAdjustments {
        let rawPrediction = predictor.predictWellnessAdjustment(metrics: metrics)
        return deriveCategoryAdjustments(from: rawPrediction, metrics: metrics)
    }

    private func deriveCategoryAdjustments(
        from prediction: Double,
        metrics: HealthMetrics
    ) -> MLCategoryAdjustments {

        let physicalRule    = rules.calculatePhysical(metrics)
        let mentalRule      = rules.calculateMental(metrics)
        let mindfulnessRule = rules.calculateMindfulness(metrics)

        // Global sentiment: +1 = model is optimistic, -1 = pessimistic
        let sentiment = (prediction - 50.0) / 50.0

        // Categories further below average receive a proportionally larger nudge
        let physicalNeed    = 1.0 - (physicalRule    / 100.0)
        let mentalNeed      = 1.0 - (mentalRule      / 100.0)
        let mindfulnessNeed = 1.0 - (mindfulnessRule / 100.0)

        let totalNeed = physicalNeed + mentalNeed + mindfulnessNeed
        guard totalNeed > 0 else { return .zero }

        let cap = ScoringConstants.maxAICategoryAdjustment

        return MLCategoryAdjustments(
            physical:    sentiment * (physicalNeed    / totalNeed) * cap,
            mental:      sentiment * (mentalNeed      / totalNeed) * cap,
            mindfulness: sentiment * (mindfulnessNeed / totalNeed) * cap
        )
    }
}

// ======================================================
// MARK: - COMBINED WELLNESS ENGINE
// ======================================================

/**
 WellnessEngine blends per-category rule scores with AI personalisation.

 Per-category blend:
   adjustedScore = clamp(ruleScore + aiAdjustment, 0, 100)

 Final composite:
   finalScore = adjustedAverage × ruleBlendWeight
              + mlMoodPrediction × mlBlendWeight

 Both dependencies are injected for full testability.
 */
class WellnessEngine: WellnessScorer {

    private let rules: RuleBasedScorer
    private let ml: MLAdjustmentProvider

    init(
        rules: RuleBasedScorer = WellnessRuleEngine(),
        ml: MLAdjustmentProvider = MLPredictionEngine()
    ) {
        self.rules = rules
        self.ml = ml
    }

    func calculateWellness(metrics: HealthMetrics) -> WellnessBreakdown {

        let rulePhysical    = rules.calculatePhysical(metrics)
        let ruleMental      = rules.calculateMental(metrics)
        let ruleMindfulness = rules.calculateMindfulness(metrics)

        let adjustments = ml.predictAdjustments(metrics: metrics)

        let physical    = (rulePhysical    + adjustments.physical).clamped(to: 0...100)
        let mental      = (ruleMental      + adjustments.mental).clamped(to: 0...100)
        let mindfulness = (ruleMindfulness + adjustments.mindfulness).clamped(to: 0...100)

        let adjustedAverage  = (physical + mental + mindfulness) / 3.0
        let mlMoodScore      = AIWellnessPredictor.shared.predictWellnessAdjustment(metrics: metrics)
        let effectiveBlend   = AIWellnessPredictor.shared.blendFactor
        let finalScore       = (adjustedAverage  * (1.0 - effectiveBlend) +
                                mlMoodScore      * effectiveBlend).clamped(to: 0...100)

        return WellnessBreakdown(
            physical:    physical,
            mental:      mental,
            mindfulness: mindfulness,
            finalScore:  finalScore
        )
    }
}

// Note: Double.clamped(to:) is defined in AIWellnessTuner.swift
