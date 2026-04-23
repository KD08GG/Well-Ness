import Foundation
import HealthKit
import CoreLocation
import UserNotifications

#if os(iOS)
import FamilyControls
#endif

// =====================================================
// MARK: - PERMISSIONS MANAGER
// =====================================================

/// Centralized manager for all runtime permissions required by the app.
/// Call these methods once at app launch or before first data collection.
class PermissionsManager {

    static let shared = PermissionsManager()

    private let healthStore = HKHealthStore()
    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {}

    // =====================================================
    // MARK: - HEALTHKIT
    // =====================================================

    func requestHealthKitPermissions(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error)")
            }
            completion(success)
        }
    }

    // =====================================================
    // MARK: - LOCATION
    // =====================================================

    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // =====================================================
    // MARK: - NOTIFICATIONS
    // =====================================================

    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            completion(granted)
        }
    }

    // =====================================================
    // MARK: - FAMILY CONTROLS (Screen Time)
    // =====================================================

    func requestFamilyControlsPermissions() async -> Bool {
        #if os(iOS)
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            return true
        } catch {
            print("Family Controls authorization failed: \(error)")
            return false
        }
        #else
        // FamilyControls no está disponible fuera de iOS
        return false
        #endif
    }
}
