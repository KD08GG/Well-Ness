import Foundation
import HealthKit

// =====================================================
// MARK: - HEALTH DATA COLLECTOR
// =====================================================

/// Handles all HealthKit data collection.
/// Used internally by `DeviceDataCollector`.
class HealthDataCollector {

    private let healthStore = HKHealthStore()

    // MARK: - Data Properties
    var steps: Double = 0
    var sleepHours: Double = 0
    var exerciseMinutes: Double = 0

    // =====================================================
    // MARK: - STEPS
    // =====================================================

    func fetchSteps(completion: @escaping () -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion()
            return
        }

        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            self.steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            completion()
        }

        healthStore.execute(query)
    }

    // =====================================================
    // MARK: - SLEEP
    // =====================================================

    func fetchSleep(completion: @escaping () -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion()
            return
        }

        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())

        let query = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { _, samples, _ in
            let totalSleep = samples?.reduce(0.0) { result, sample in
                result + sample.endDate.timeIntervalSince(sample.startDate)
            } ?? 0
            self.sleepHours = totalSleep / 3600
            completion()
        }

        healthStore.execute(query)
    }

    // =====================================================
    // MARK: - EXERCISE
    // =====================================================

    func fetchExerciseMinutes(completion: @escaping () -> Void) {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion()
            return
        }

        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date())

        let query = HKStatisticsQuery(
            quantityType: exerciseType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            self.exerciseMinutes = result?.sumQuantity()?.doubleValue(for: .minute()) ?? 0
            completion()
        }

        healthStore.execute(query)
    }

    // =====================================================
    // MARK: - DAILY RESET
    // =====================================================

    func resetDailyData() {
        steps = 0
        sleepHours = 0
        exerciseMinutes = 0
    }
}
