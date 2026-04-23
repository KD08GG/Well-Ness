import Foundation

// ======================================================
// MARK: - RECOMMENDATION ENGINE
// ======================================================

/**
 RecommendationEngine maintains the session state for recommendation cycling
 and ranks candidates using whichever `RecommendationScorer` is injected.

 The default scorer is `AIRecommendationScorer`, which blends rule-based
 category alignment with an AI-predicted relevance signal. Swap it for
 `RuleBasedRecommendationScorer` in unit tests for deterministic output.

 Usage:
 - `getBestRecommendation(for:)` → top-ranked recommendation not yet rejected.
 - `rejectRecommendation(_:)`   → exclude from this session; surface next best.
 - `acceptRecommendation(_:)`   → user committed; reset session.
 - `completeRecommendation(_:)` → user finished;  reset session.
 */
class RecommendationEngine {

    private let database: RecommendationDatabase
    private let scorer:   RecommendationScorer

    private var recommendations: [Recommendation]
    private var excludedIDs: Set<UUID> = []

    init(
        database: RecommendationDatabase = RecommendationDatabase(),
        scorer:   RecommendationScorer   = AIRecommendationScorer()
    ) {
        self.database = database
        self.scorer   = scorer
        self.recommendations = database.loadRecommendations()
    }

    // ======================================================
    // MARK: - PUBLIC API
    // ======================================================

    /// Returns the highest-scored recommendation not yet rejected this session.
    /// Resets exclusions automatically when the pool is exhausted.
    func getBestRecommendation(for wellness: WellnessState) -> Recommendation? {
        let pool = availablePool()
        return pool.max {
            scorer.calculateScore(recommendation: $0, wellness: wellness) <
            scorer.calculateScore(recommendation: $1, wellness: wellness)
        }
    }

    func rejectRecommendation(_ recommendation: Recommendation) {
        excludedIDs.insert(recommendation.id)
    }

    func acceptRecommendation(_ recommendation: Recommendation) {
        print("Accepted recommendation: \(recommendation.title)")
        resetExclusions()
    }

    func completeRecommendation(_ recommendation: Recommendation) {
        print("Completed recommendation: \(recommendation.title)")
        resetExclusions()
    }

    // ======================================================
    // MARK: - PRIVATE
    // ======================================================

    private func availablePool() -> [Recommendation] {
        let available = recommendations.filter { !excludedIDs.contains($0.id) }
        if available.isEmpty {
            resetExclusions()
            return recommendations
        }
        return available
    }

    private func resetExclusions() {
        excludedIDs.removeAll()
    }
}
