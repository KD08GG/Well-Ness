import Foundation
import Observation

// ======================================================
// MARK: - WELLNESS STORE
// ======================================================

@Observable
@MainActor
final class WellnessStore {

    // ======================================================
    // MARK: - SINGLETON
    // ======================================================

    static let shared = WellnessStore()

    private init() {}

    // ======================================================
    // MARK: - CURRENT WELLNESS SCORES  (0 – 100)
    // ======================================================

    private(set) var physical: Double = 0
    private(set) var mental: Double = 0
    private(set) var mindfulness: Double = 0
    private(set) var finalScore: Double = 0

    // ======================================================
    // MARK: - RAW METRICS (para HomeDashboard)
    // ======================================================

    private(set) var steps: Double = 0
    private(set) var sleepHours: Double = 0
    private(set) var screenTimeHours: Double = 0
    private(set) var locationsVisited: Double = 0

    // ======================================================
    // MARK: - CURRENT RECOMMENDATION
    // ======================================================

    private(set) var currentRecommendation: Recommendation?

    // ======================================================
    // MARK: - METADATA
    // ======================================================

    private(set) var lastUpdated: Date?
    private(set) var isLoading: Bool = false

    // ======================================================
    // MARK: - BOOST PROTECTION
    // Guarda los deltas activos para re-aplicarlos si llega
    // un runDailyAnalysis mientras el boost sigue vigente.
    // ======================================================

    private var boostPhysicalDelta:    Double = 0
    private var boostMentalDelta:      Double = 0
    private var boostMindfulnessDelta: Double = 0
    /// Boost protegido durante 5 minutos tras completar una actividad
    private var boostProtectedUntil: Date? = nil

    var isBoostActive: Bool {
        guard let until = boostProtectedUntil else { return false }
        return Date() < until
    }

    // ======================================================
    // MARK: - COMPUTED HELPERS
    // ======================================================

    var breakdown: WellnessBreakdown {
        WellnessBreakdown(
            physical:    physical,
            mental:      mental,
            mindfulness: mindfulness,
            finalScore:  finalScore
        )
    }

    var weakestCategory: WellnessCategory {
        let scores: [(WellnessCategory, Double)] = [
            (.physical,    physical),
            (.mental,      mental),
            (.mindfulness, mindfulness)
        ]
        return scores.min(by: { $0.1 < $1.1 })?.0 ?? .physical
    }

    var overallProgress: Double {
        finalScore / 100.0
    }

    // ======================================================
    // MARK: - UPDATE  (called by WellnessBackend only)
    // Si hay boost activo, lo re-aplica encima del analisis
    // para que el usuario no vea sus puntos retroceder.
    // ======================================================

    func update(from breakdown: WellnessBreakdown, recommendation: Recommendation?) {
        if isBoostActive {
            physical    = min(100, breakdown.physical    + boostPhysicalDelta)
            mental      = min(100, breakdown.mental      + boostMentalDelta)
            mindfulness = min(100, breakdown.mindfulness + boostMindfulnessDelta)
            finalScore  = (physical + mental + mindfulness) / 3.0
        } else {
            physical    = breakdown.physical
            mental      = breakdown.mental
            mindfulness = breakdown.mindfulness
            finalScore  = breakdown.finalScore
        }

        currentRecommendation = recommendation
        lastUpdated = Date()
        isLoading   = false
    }

    /// Version extendida que tambien almacena metricas crudas para el dashboard.
    func update(from breakdown: WellnessBreakdown,
                recommendation: Recommendation?,
                metrics: HealthMetrics) {
        update(from: breakdown, recommendation: recommendation)
        steps             = metrics.steps
        sleepHours        = metrics.sleepHours
        screenTimeHours   = metrics.screenTimeHours
        locationsVisited  = metrics.locationsVisited
    }

    func beginLoading() {
        isLoading = true
    }

    // ======================================================
    // MARK: - ACTIVITY BOOST
    // ======================================================

    struct BoostResult {
        let physicalDelta:    Double
        let mentalDelta:      Double
        let mindfulnessDelta: Double
    }

    /// Aplica boost inmediato y guarda los deltas para sobrevivir un re-analisis.
    @discardableResult
    func applyActivityBoost(from recommendation: Recommendation) -> BoostResult {
        let factor: Double = 15.0

        let pDelta = recommendation.physicalWeight    > 0.2 ? recommendation.physicalWeight    * factor : 0
        let mDelta = recommendation.mentalWeight      > 0.2 ? recommendation.mentalWeight      * factor : 0
        let sDelta = recommendation.mindfulnessWeight > 0.2 ? recommendation.mindfulnessWeight * factor : 0

        // Acumular deltas (soporta varias actividades seguidas)
        boostPhysicalDelta    += pDelta
        boostMentalDelta      += mDelta
        boostMindfulnessDelta += sDelta

        // Aplicar inmediatamente a los scores visibles
        if pDelta > 0 { physical    = min(100, physical    + pDelta) }
        if mDelta > 0 { mental      = min(100, mental      + mDelta) }
        if sDelta > 0 { mindfulness = min(100, mindfulness + sDelta) }

        finalScore  = (physical + mental + mindfulness) / 3.0
        lastUpdated = Date()

        // Proteger 5 minutos
        boostProtectedUntil = Date().addingTimeInterval(5 * 60)

        return BoostResult(physicalDelta: pDelta, mentalDelta: mDelta, mindfulnessDelta: sDelta)
    }
}

// ======================================================
// MARK: - WELLNESS CATEGORY
// ======================================================

enum WellnessCategory: String, CaseIterable {
    case physical    = "Physical"
    case mental      = "Mental"
    case mindfulness = "Mindfulness"
}
