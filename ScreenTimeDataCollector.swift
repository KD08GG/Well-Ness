import Foundation
#if os(iOS)
import DeviceActivity
import FamilyControls
#endif


// =====================================================
// MARK: - SCREEN TIME DATA COLLECTOR
// =====================================================

/**
 Handles screen time data collection and estimation.
 Used internally by `DeviceDataCollector`.

 Because Apple's Screen Time API requires the Family Controls entitlement
 (restricted to parental-control use cases), programmatic access to real
 screen time data is not available to general apps. When permission is
 granted, this class starts a `DeviceActivityMonitor` session to accumulate
 real-time signals. When permission is denied, it falls back to time-of-day
 estimates.

 All estimation values (hours, unlocks, category ratios) come from
 `ScoringConstants.ScreenTimeEstimates` and `ScoringConstants.ScreenTimeRatios`
 — no magic numbers in this file.
 */
class ScreenTimeDataCollector {

    // MARK: - Data Properties
    var screenTimeHours: Double = 0
    var unlockCount: Double = 0
    var productiveUsageRatio: Double = 0
    var socialMediaTime: Double = 0
    var passiveRatio: Double = 0
    var diversityScore: Double = 0
    var educationTime: Double = 0
    var productivityTime: Double = 0

    // =====================================================
    // MARK: - SCREEN TIME FETCHING
    // =====================================================

    func fetchScreenTimeData(completion: @escaping () -> Void) {
        Task {
            let hasPermission = await PermissionsManager.shared.requestFamilyControlsPermissions()

            if hasPermission {
                await startDeviceActivityMonitoring()
                await populateScreenTimeMetrics()
            } else {
                populateScreenTimeMetrics(from: estimateDeviceUsage())
            }

            completion()
        }
    }

    // =====================================================
    // MARK: - DEVICE ACTIVITY MONITORING
    // =====================================================
    
    private func startDeviceActivityMonitoring() async {
        #if os(iOS)
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd:   DateComponents(hour: 23, minute: 59),
            repeats:       false,
            warningTime:   nil
        )
        let activityName = DeviceActivityName("wellnessScreenTimeMonitor")
        do {
            try DeviceActivityCenter().startMonitoring(activityName, during: schedule)
        } catch {
            print("Failed to start device activity monitoring: \(error)")
        }
        #endif
    }

    // =====================================================
    // MARK: - METRICS POPULATION
    // =====================================================

    /// Async path used when Family Controls permission is granted.
    /// Apple still doesn't surface historical totals, so we read the
    /// same time-based estimates — but the monitoring session will allow
    /// real data to be accumulated going forward via a DeviceActivityReport extension.
    private func populateScreenTimeMetrics() async {
        populateScreenTimeMetrics(from: estimateDeviceUsage())
    }

    /// Shared core that sets all published properties from a single snapshot.
    private func populateScreenTimeMetrics(from usage: (hours: Double, unlocks: Int)) {
        screenTimeHours = usage.hours
        unlockCount     = Double(usage.unlocks)

        let breakdown = categoryBreakdown(for: screenTimeHours)
        productivityTime = breakdown.productivity
        educationTime    = breakdown.education
        socialMediaTime  = breakdown.social

        productiveUsageRatio = (productivityTime + educationTime) / max(screenTimeHours, 1.0)
        passiveRatio         = socialMediaTime / max(screenTimeHours, 1.0)
        diversityScore       = min(5.0, unlockCount / 10.0)
    }

    // =====================================================
    // MARK: - ESTIMATION HELPERS
    // =====================================================

    /// Estimates (screenTimeHours, unlockCount) from time-of-day and day-of-week.
    /// All values come from `ScoringConstants.ScreenTimeEstimates`.
    private func estimateDeviceUsage() -> (hours: Double, unlocks: Int) {
        let calendar = Calendar.current
        let now      = Date()
        let hour     = calendar.component(.hour, from: now)

        let E = ScoringConstants.ScreenTimeEstimates.self
        let base: (hours: Double, unlocks: Int)

        switch hour {
        case 6...8:   base = (E.morning.hours,    E.morning.unlocks)
        case 9...12:  base = (E.midMorning.hours,  E.midMorning.unlocks)
        case 13...17: base = (E.afternoon.hours,   E.afternoon.unlocks)
        case 18...22: base = (E.evening.hours,     E.evening.unlocks)
        default:      base = (E.night.hours,       E.night.unlocks)
        }

        let weekday   = calendar.component(.weekday, from: now)
        let isWeekend = weekday == 1 || weekday == 7
        let multiplier = isWeekend ? E.weekendMultiplier : 1.0

        return (
            hours:   base.hours * multiplier,
            unlocks: Int((Double(base.unlocks) * multiplier).rounded())
        )
    }

    /// Splits total screen time into productivity / education / social buckets.
    /// Ratios come from `ScoringConstants.ScreenTimeRatios`.
    private func categoryBreakdown(for totalHours: Double) -> (productivity: Double, education: Double, social: Double) {
        let hour = Calendar.current.component(.hour, from: Date())

        let R = ScoringConstants.ScreenTimeRatios.self
        let ratios: (productivity: Double, education: Double, social: Double)

        switch hour {
        case 9...17: ratios = R.workHours
        case 18...22: ratios = R.eveningHours
        default:      ratios = R.defaultHours
        }

        return (
            productivity: totalHours * ratios.productivity,
            education:    totalHours * ratios.education,
            social:       totalHours * ratios.social
        )
    }

    // =====================================================
    // MARK: - DAILY RESET
    // =====================================================

    func resetDailyData() {
        screenTimeHours      = 0
        unlockCount          = 0
        productiveUsageRatio = 0
        socialMediaTime      = 0
        passiveRatio         = 0
        diversityScore       = 0
        educationTime        = 0
        productivityTime     = 0
    }
}
