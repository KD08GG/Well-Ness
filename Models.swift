import Foundation

// ======================================================
// MARK: - SHARED DATA MODELS
// ======================================================

/// Represents the raw health and activity metrics collected from the device.
struct HealthMetrics {
    var steps: Double
    var sleepHours: Double
    var exerciseMinutes: Double

    var screenTimeHours: Double
    var unlockCount: Double
    var productiveUsageRatio: Double

    var locationsVisited: Double
    var routineCompletionRatio: Double

    var socialMediaTime: Double = 0
    var passiveRatio: Double = 0
    var diversityScore: Double = 0
    var educationTime: Double = 0
    var productivityTime: Double = 0
}

/// Represents the current wellness state with scores for each category.
/// - physical: Physical wellness score (0–100)
/// - mental: Mental wellness score (0–100)
/// - mindfulness: Mindfulness / emotional wellness score (0–100)
struct WellnessState {
    let physical: Double
    let mental: Double
    let mindfulness: Double
}

/// Breakdown of wellness scores including individual categories and final composite score.
struct WellnessBreakdown {
    var physical: Double
    var mental: Double
    var mindfulness: Double
    var finalScore: Double
}

/// A recommendation with weights for each wellness category.
struct Recommendation: Identifiable {
    let id: UUID
    let title: String
    let description: String

    /// Estimated improvement weight for physical wellness (0–1)
    let physicalWeight: Double
    /// Estimated improvement weight for mental wellness (0–1)
    let mentalWeight: Double
    /// Estimated improvement weight for mindfulness wellness (0–1)
    let mindfulnessWeight: Double

    /// General benefit score (0–1)
    let estimatedBenefit: Double

    /// Approximate task duration in minutes
    let taskTime: Double
}

/// Actions a user can take on a recommendation.
enum RecommendationAction {
    case reject
    case accept
    case complete
}
