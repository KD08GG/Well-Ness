import Foundation

// ======================================================
// MARK: - RECOMMENDATION SYSTEM
// ======================================================

// This file provides a single convenience namespace for the recommendation subsystem.
// All components are defined in their own files:
//
//   RecommendationDatabase.swift   — static recommendation content
//   RecommendationScoring.swift    — RecommendationScorer protocol + default engine
//   RecommendationEngine.swift     — session state and ranking logic
//   RecommendationPipeline.swift   — public API consumed by WellnessBackend / ViewModels
//
// To use the full system from a ViewModel or view layer:
//
//   let pipeline = RecommendationPipeline()
//   let rec = pipeline.requestRecommendation(physical: 40, mental: 60, mindfulness: 30)
//
// To swap in a custom scorer (e.g. for A/B testing):
//
//   let engine = RecommendationEngine(scorer: MyCustomScorer())
//   let pipeline = RecommendationPipeline(engine: engine)

/// Convenience typealias — use `RecommendationSystem.Pipeline` in contexts where
/// the full name would be repetitive.
enum RecommendationSystem {
    typealias Pipeline = RecommendationPipeline
    typealias Engine   = RecommendationEngine
    typealias Scorer   = RecommendationScorer
    typealias Database = RecommendationDatabase
}
