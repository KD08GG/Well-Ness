import Foundation

// ======================================================
// MARK: - DATA PROVIDER PROTOCOL
// ======================================================

/// Protocol for providing health metrics data.
/// Conform to this protocol to supply custom or mock data sources.
protocol HealthDataProvider {
    func fetchMetrics(completion: @escaping (HealthMetrics) -> Void)
}
