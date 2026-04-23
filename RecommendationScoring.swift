import Foundation

// ======================================================
// MARK: - RECOMMENDATION SCORING PROTOCOL
// ======================================================

/// Scores a recommendation against the current wellness state.
/// Implement this protocol to swap in alternative ranking strategies.
protocol RecommendationScorer {
    func calculateScore(recommendation: Recommendation, wellness: WellnessState) -> Double
}

// ======================================================
// MARK: - RULE-BASED SCORING ENGINE
// ======================================================

/**
 RuleBasedRecommendationScorer ranks recommendations using three deterministic factors:

 1. Category alignment (60%) — how well the recommendation targets the user's
    weakest wellness categories.
 2. Estimated benefit (25%) — the recommendation's general expected impact.
 3. Time efficiency (15%) — shorter tasks rank higher, all else being equal.

 All weights come from `ScoringConstants`.
 */
class RuleBasedRecommendationScorer: RecommendationScorer {

    func calculateScore(
        recommendation: Recommendation,
        wellness: WellnessState
    ) -> Double {

        let physicalNeed    = (100 - wellness.physical)    / 100
        let mentalNeed      = (100 - wellness.mental)      / 100
        let mindfulnessNeed = (100 - wellness.mindfulness) / 100

        let categoryScore =
            recommendation.physicalWeight    * physicalNeed +
            recommendation.mentalWeight      * mentalNeed +
            recommendation.mindfulnessWeight * mindfulnessNeed

        let benefitScore   = recommendation.estimatedBenefit
        let timeEfficiency = 1.0 / max(recommendation.taskTime, 1.0)

        return categoryScore   * ScoringConstants.recommendationCategoryWeight +
               benefitScore    * ScoringConstants.recommendationBenefitWeight +
               timeEfficiency  * ScoringConstants.recommendationTimeWeight
    }
}

// ======================================================
// MARK: - AI RECOMMENDATION SCORER
// ======================================================

/**
 AIRecommendationScorer blends the rule-based score with an AI-predicted
 relevance signal from `AIWellnessPredictor`.

 The AI relevance signal is derived from the model's mood prediction and the
 per-category need profile. Recommendations whose category weights align most
 with the categories the AI identifies as most in need receive a bonus.

 Blend formula:
   finalScore = ruleScore × recommendationRuleWeight
              + aiRelevance × recommendationAIWeight

 Both weights come from `ScoringConstants` so they can be tuned centrally.

 Use this scorer (the default) for live scoring. Use `RuleBasedRecommendationScorer`
 directly when you want deterministic, testable output.
 */
class AIRecommendationScorer: RecommendationScorer {

    private let ruleScorer = RuleBasedRecommendationScorer()
    private let predictor  = AIWellnessPredictor.shared

    func calculateScore(
        recommendation: Recommendation,
        wellness: WellnessState
    ) -> Double {

        let ruleScore    = ruleScorer.calculateScore(recommendation: recommendation, wellness: wellness)
        let aiRelevance  = predictAIRelevance(recommendation: recommendation, wellness: wellness)

        return ruleScore   * ScoringConstants.recommendationRuleWeight +
               aiRelevance * ScoringConstants.recommendationAIWeight
    }

    // ======================================================
    // MARK: - PRIVATE
    // ======================================================

    /**
     Predicts how relevant a recommendation is to the user's AI-personalised needs.

     Steps:
     1. Build a `HealthMetrics` proxy from the wellness scores so the predictor
        has something concrete to work with.
     2. Get the model's mood prediction (0–100) and invert it to a need signal.
     3. Weight the recommendation's category contributions by the AI-derived need.
     4. Normalise to [0, 1].
     */
    private func predictAIRelevance(
        recommendation: Recommendation,
        wellness: WellnessState
    ) -> Double {

        // Convert wellness scores → proxy metrics for the predictor
        let proxyMetrics = metricsProxy(from: wellness)
        let moodPrediction = predictor.predictWellnessAdjustment(metrics: proxyMetrics)

        // Invert: low mood → high need for intervention
        let overallNeed = 1.0 - (moodPrediction / 100.0)

        // AI-weighted need per category (categories with lower AI confidence get more weight)
        let physicalNeed    = (1.0 - wellness.physical    / 100.0) * overallNeed
        let mentalNeed      = (1.0 - wellness.mental      / 100.0) * overallNeed
        let mindfulnessNeed = (1.0 - wellness.mindfulness / 100.0) * overallNeed

        let aiRelevance =
            recommendation.physicalWeight    * physicalNeed +
            recommendation.mentalWeight      * mentalNeed +
            recommendation.mindfulnessWeight * mindfulnessNeed

        // Normalise: maximum possible value is 3 × overallNeed (if all weights = 1)
        let maxPossible = 3.0 * overallNeed
        return maxPossible > 0 ? (aiRelevance / maxPossible) : 0
    }

    /**
     Builds a minimal `HealthMetrics` proxy from `WellnessState` scores so the
     CoreML predictor receives valid input even when raw metrics aren't available
     at recommendation-scoring time.

     Values are reverse-engineered from the scoring formulas using the
     mid-point of each category's healthy range.
     */
    private func metricsProxy(from wellness: WellnessState) -> HealthMetrics {
        return HealthMetrics(
            steps:                 (wellness.physical    / 100) * ScoringConstants.dailyStepGoal,
            sleepHours:            (wellness.physical    / 100) * ScoringConstants.optimalSleepHours,
            exerciseMinutes:       (wellness.physical    / 100) * ScoringConstants.dailyExerciseMinutes,
            screenTimeHours:       (1 - wellness.mental  / 100) * ScoringConstants.maxHealthyScreenTimeHours,
            unlockCount:           (1 - wellness.mental  / 100) * ScoringConstants.maxHealthyUnlockCount,
            productiveUsageRatio:  wellness.mindfulness  / 100,
            locationsVisited:      (wellness.mindfulness / 100) * ScoringConstants.maxRoutineLocations,
            routineCompletionRatio: wellness.mindfulness / 100
        )
    }
}
