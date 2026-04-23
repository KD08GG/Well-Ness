import Foundation

// =====================================================
// MARK: - DEVICE DATA COLLECTOR
// =====================================================

/**
 DeviceDataCollector orchestrates all platform data collection modules.
 It gathers HealthKit metrics, location activity patterns, and screen time
 estimates from the separate collector classes.

 Conforms to `HealthDataProvider` so it can be injected into `WellnessBackend`
 or replaced with any alternative implementation (e.g. a mock for testing).
 */
class DeviceDataCollector: HealthDataProvider {

    static let shared = DeviceDataCollector()

    private let healthCollector = HealthDataCollector()
    private let locationCollector = LocationDataCollector()
    private let screenTimeCollector = ScreenTimeDataCollector()

    private init() {}

    // =====================================================
    // MARK: - METRICS COLLECTION
    // =====================================================

    func fetchMetrics(completion: @escaping (HealthMetrics) -> Void) {
        requestPermissions()

        let group = DispatchGroup()

        group.enter()
        healthCollector.fetchSteps { group.leave() }

        group.enter()
        healthCollector.fetchSleep { group.leave() }

        group.enter()
        healthCollector.fetchExerciseMinutes { group.leave() }

        group.enter()
        locationCollector.fetchLocationData { group.leave() }

        group.enter()
        screenTimeCollector.fetchScreenTimeData { group.leave() }

        group.notify(queue: .main) {
            let metrics = HealthMetrics(
                steps: self.healthCollector.steps,
                sleepHours: self.healthCollector.sleepHours,
                exerciseMinutes: self.healthCollector.exerciseMinutes,
                screenTimeHours: self.screenTimeCollector.screenTimeHours,
                unlockCount: self.screenTimeCollector.unlockCount,
                productiveUsageRatio: self.screenTimeCollector.productiveUsageRatio,
                locationsVisited: self.locationCollector.locationsVisited,
                routineCompletionRatio: self.locationCollector.routineCompletionRatio,
                socialMediaTime: self.screenTimeCollector.socialMediaTime,
                passiveRatio: self.screenTimeCollector.passiveRatio,
                diversityScore: self.screenTimeCollector.diversityScore,
                educationTime: self.screenTimeCollector.educationTime,
                productivityTime: self.screenTimeCollector.productivityTime
            )
            completion(metrics)
        }
    }

    // =====================================================
    // MARK: - PERMISSIONS
    // =====================================================
    
    private func requestPermissions() {
        PermissionsManager.shared.requestHealthKitPermissions { _ in }
        PermissionsManager.shared.requestLocationPermissions()
        PermissionsManager.shared.requestNotificationPermissions { _ in }
        //#if os(iOS)
    }

    // =====================================================
    // MARK: - DAILY RESET
    // =====================================================

    func resetDailyData() {
        healthCollector.resetDailyData()
        locationCollector.resetDailyData()
        screenTimeCollector.resetDailyData()
    }
}
