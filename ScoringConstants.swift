import Foundation

// ======================================================
// MARK: - SCORING CONSTANTS
// ======================================================

/**
 ScoringConstants is the single source of truth for every threshold and weight
 used across the wellness scoring pipeline.

 Centralising these values means:
 - No magic numbers scattered across scoring files.
 - Easy to tune as the product evolves or research suggests better targets.
 - Future versions can make these user-configurable (e.g. athlete vs sedentary profiles)
   by replacing this struct with a UserDefaults-backed or server-driven equivalent.
*/
enum ScoringConstants {

    // ======================================================
    // MARK: - PHYSICAL TARGETS
    // ======================================================

    /// Daily step goal used as the normalisation ceiling for step scoring.
    static let dailyStepGoal: Double = 10_000

    /// Optimal sleep duration in hours.
    static let optimalSleepHours: Double = 8

    /// Daily exercise target in minutes (aligns with WHO recommendation).
    static let dailyExerciseMinutes: Double = 30

    // ======================================================
    // MARK: - MENTAL TARGETS
    // ======================================================

    /// Maximum healthy daily screen time in hours before score degrades to zero.
    static let maxHealthyScreenTimeHours: Double = 8

    /// Maximum healthy daily phone unlock count before score degrades to zero.
    static let maxHealthyUnlockCount: Double = 100

    // ======================================================
    // MARK: - MINDFULNESS TARGETS
    // ======================================================

    /// Number of distinct locations beyond which the routine-score calculation caps.
    static let maxRoutineLocations: Double = 5

    /// Threshold below which productive usage ratio is considered low.
    static let lowProductivityThreshold: Double = 0.3

    // ======================================================
    // MARK: - SCORING WEIGHTS — PHYSICAL
    // ======================================================

    static let physicalStepWeight:     Double = 0.40
    static let physicalSleepWeight:    Double = 0.35
    static let physicalExerciseWeight: Double = 0.25

    // ======================================================
    // MARK: - SCORING WEIGHTS — MENTAL
    // ======================================================

    static let mentalScreenWeight:  Double = 0.35
    static let mentalUnlockWeight:  Double = 0.30
    static let mentalSleepWeight:   Double = 0.35

    // ======================================================
    // MARK: - SCORING WEIGHTS — MINDFULNESS
    // ======================================================

    static let mindfulnessProductivityWeight: Double = 0.40
    static let mindfulnessMovementWeight:     Double = 0.30
    static let mindfulnessRoutineWeight:      Double = 0.30

    // ======================================================
    // MARK: - AI BLEND WEIGHTS
    // ======================================================

    /// Fraction of the final wellness score driven by the rule engine.
    static let ruleBlendWeight: Double = 0.70

    /// Fraction of the final wellness score driven by the CoreML model.
    static let mlBlendWeight: Double = 0.30

    /// Fraction of the recommendation score driven by rule-based ranking.
    static let recommendationRuleWeight: Double = 0.65

    /// Fraction of the recommendation score driven by AI-predicted relevance.
    static let recommendationAIWeight: Double = 0.35

    // ======================================================
    // MARK: - RECOMMENDATION SCORING WEIGHTS
    // ======================================================

    static let recommendationCategoryWeight: Double = 0.60
    static let recommendationBenefitWeight:  Double = 0.25
    static let recommendationTimeWeight:     Double = 0.15

    // ======================================================
    // MARK: - AI PER-CATEGORY ADJUSTMENT
    // ======================================================

    /// Maximum points the AI model can shift an individual category score (±).
    static let maxAICategoryAdjustment: Double = 15.0

    // ======================================================
    // MARK: - ADAPTIVE LEARNING
    // ======================================================

    /// Number of input features fed into the adaptive predictor.
    /// Matches the 8 HealthMetrics fields used for prediction.
    static let adaptiveFeatureCount: Int = 8

    /// Initial weight assigned to every feature before personalisation begins.
    /// Set to 1/featureCount so the initial weighted sum starts at a neutral
    /// 0.5 (→ 50/100 prediction) when all normalised features equal ~0.5.
    static let adaptiveInitialWeight: Double = 1.0 / Double(adaptiveFeatureCount)

    /// Gradient descent step size for online weight updates.
    /// Small enough for stability; large enough to converge within ~30 feedback events.
    /// Increase if adaptation is too slow; decrease if scores oscillate.
    static let adaptiveLearningRate: Double = 0.01

    /// L2 regularisation factor applied after each weight update.
    /// Prevents any single feature weight from growing disproportionately large.
    /// Set to 0 to disable.
    static let adaptiveWeightDecay: Double = 0.001

    /// Minimum allowed value for any single adaptive weight.
    static let adaptiveMinWeight: Double = 0.0

    /// Maximum allowed value for any single adaptive weight.
    static let adaptiveMaxWeight: Double = 1.0

    /// Number of mood feedback entries required before the adaptive predictor
    /// reaches its full `mlBlendWeight` contribution.
    /// Below this threshold its influence ramps up linearly from 0, so the
    /// rule engine dominates until the predictor has meaningful data.
    static let adaptiveWarmupEntries: Int = 5

    // ======================================================
    // MARK: - SCREEN TIME ESTIMATION
    // (used only when Family Controls permission is denied)
    // ======================================================

    struct ScreenTimeEstimates {
        /// (estimatedHours, estimatedUnlocks) keyed by hour-of-day range tag
        static let morning:   (hours: Double, unlocks: Int) = (1.5, 15)
        static let midMorning:(hours: Double, unlocks: Int) = (2.5, 25)
        static let afternoon: (hours: Double, unlocks: Int) = (3.0, 30)
        static let evening:   (hours: Double, unlocks: Int) = (4.0, 40)
        static let night:     (hours: Double, unlocks: Int) = (1.0, 10)
        static let weekendMultiplier: Double = 1.3
    }

    struct ScreenTimeRatios {
        static let workHours   = (productivity: 0.6, education: 0.2, social: 0.2)
        static let eveningHours = (productivity: 0.3, education: 0.2, social: 0.5)
        static let defaultHours = (productivity: 0.4, education: 0.2, social: 0.4)
    }
}
