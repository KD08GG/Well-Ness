import Foundation
import CoreLocation

// =====================================================
// MARK: - LOCATION DATA COLLECTOR
// =====================================================

/// Handles location tracking and activity pattern metrics.
/// Used internally by `DeviceDataCollector`.
class LocationDataCollector: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var locationVisits: [CLLocation] = []

    // MARK: - Data Properties
    var locationsVisited: Double = 0
    var routineCompletionRatio: Double = 0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // =====================================================
    // MARK: - LOCATION DATA FETCHING
    // =====================================================

    func fetchLocationData(completion: @escaping () -> Void) {
        let oneDayAgo = Date().addingTimeInterval(-24 * 3600)
        let recentLocations = locationVisits.filter { $0.timestamp > oneDayAgo }

        var significantLocations: [CLLocation] = []
        for location in recentLocations {
            if significantLocations.isEmpty ||
               significantLocations.last!.distance(from: location) > 500 {
                significantLocations.append(location)
            }
        }

        locationsVisited = Double(significantLocations.count)

        // Lower diversity (fewer locations) reflects a more predictable routine
        let maxStableLocations = 5.0
        routineCompletionRatio = max(0.0, min(1.0, (maxStableLocations - locationsVisited + 1) / maxStableLocations))

        completion()
    }

    // =====================================================
    // MARK: - CLLocationManagerDelegate
    // =====================================================

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationVisits.append(location)
        let oneDayAgo = Date().addingTimeInterval(-24 * 3600)
        locationVisits = locationVisits.filter { $0.timestamp > oneDayAgo }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }

    // =====================================================
    // MARK: - DAILY RESET
    // =====================================================

    func resetDailyData() {
        locationVisits.removeAll()
        locationsVisited = 0
        routineCompletionRatio = 0
    }
}
