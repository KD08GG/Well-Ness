import Foundation

// ======================================================
// MARK: - RECOMMENDATION PIPELINE
// ======================================================

/**
 RecommendationPipeline is the public-facing entry point for the recommendation system.

 It wraps `RecommendationEngine` and converts the three wellness scores into a
 `WellnessState` so callers (e.g. ViewModels, `WellnessBackend`) never need to
 construct the internal model directly.

 This layer is intentionally thin — all ranking logic lives in `RecommendationEngine`
 and `RecommendationScorer`, keeping this class easy to test and replace.
 */
class RecommendationPipeline {

    private let engine: RecommendationEngine

    init(engine: RecommendationEngine = RecommendationEngine()) {
        self.engine = engine
    }

    // ======================================================
    // MARK: - PUBLIC API
    // ======================================================

    /// Returns the best available recommendation for the given wellness scores.
    func requestRecommendation(
        physical: Double,
        mental: Double,
        mindfulness: Double
    ) -> Recommendation? {
        let wellness = WellnessState(
            physical: physical,
            mental: mental,
            mindfulness: mindfulness
        )
        return engine.getBestRecommendation(for: wellness)
    }

    func reject(_ recommendation: Recommendation) {
        engine.rejectRecommendation(recommendation)
    }

    func accept(_ recommendation: Recommendation) {
        engine.acceptRecommendation(recommendation)
    }

    func complete(_ recommendation: Recommendation) {
        engine.completeRecommendation(recommendation)
    }
}
