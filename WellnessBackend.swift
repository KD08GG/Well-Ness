import Foundation

// ======================================================
// MARK: - FEEDBACK LOGGER
// ======================================================

class FeedbackLogger {

    private let fileURL: URL

    init(filename: String = "wellness_training_data.csv") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documents.appendingPathComponent(filename)
        createFileIfNeeded()
    }

    private func createFileIfNeeded() {
        guard !FileManager.default.fileExists(atPath: fileURL.path) else { return }
        let header = "steps,sleepHours,exerciseMinutes,screenTimeHours,unlockCount," +
                     "productiveUsageRatio,locationsVisited,routineCompletionRatio,moodScore\n"
        try? header.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    func log(metrics: HealthMetrics, moodScore: Double) {
        let row = "\(metrics.steps),\(metrics.sleepHours),\(metrics.exerciseMinutes)," +
                  "\(metrics.screenTimeHours),\(metrics.unlockCount)," +
                  "\(metrics.productiveUsageRatio),\(metrics.locationsVisited)," +
                  "\(metrics.routineCompletionRatio),\(moodScore)\n"

        if let handle = try? FileHandle(forWritingTo: fileURL) {
            handle.seekToEndOfFile()
            handle.write(row.data(using: .utf8)!)
            handle.closeFile()
        }
    }

    func getFilePath() -> String { fileURL.path }
}

// ======================================================
// MARK: - TRAINING DATA SERVICE
// ======================================================

class TrainingDataService {

    private let logger: FeedbackLogger

    init(logger: FeedbackLogger = FeedbackLogger()) {
        self.logger = logger
    }

    func recordDay(metrics: HealthMetrics, userMood: Double) {
        logger.log(metrics: metrics, moodScore: userMood)
    }

    func exportPath() -> String { logger.getFilePath() }
}

// ======================================================
// MARK: - WELLNESS BACKEND
// ======================================================

class WellnessBackend {

    private let dataProvider:           HealthDataProvider
    private let wellnessEngine:         WellnessScorer
    private let recommendationPipeline: RecommendationPipeline
    private let trainer:                TrainingDataService
    private let store:                  WellnessStore
    private let predictor:              AIWellnessPredictor

    private var lastMetrics: HealthMetrics?

    init(
        dataProvider:           HealthDataProvider    = DeviceDataCollector.shared,
        wellnessEngine:         WellnessScorer         = WellnessEngine(),
        recommendationPipeline: RecommendationPipeline = RecommendationPipeline(),
        trainer:                TrainingDataService    = TrainingDataService(),
        store:                  WellnessStore          = .shared,
        predictor:              AIWellnessPredictor    = .shared
    ) {
        self.dataProvider           = dataProvider
        self.wellnessEngine         = wellnessEngine
        self.recommendationPipeline = recommendationPipeline
        self.trainer                = trainer
        self.store                  = store
        self.predictor              = predictor
    }

    func runDailyAnalysis(
        userMood: Double? = nil,
        completion: @escaping (WellnessBreakdown, Recommendation?) -> Void = { _, _ in }
    ) {
        Task { @MainActor in
            store.beginLoading()
        }

        dataProvider.fetchMetrics { [weak self] metrics in
            guard let self else { return }

            self.lastMetrics = metrics

            let breakdown = self.wellnessEngine.calculateWellness(metrics: metrics)

            let recommendation = self.recommendationPipeline.requestRecommendation(
                physical:    breakdown.physical,
                mental:      breakdown.mental,
                mindfulness: breakdown.mindfulness
            )

            if let mood = userMood {
                self.trainer.recordDay(metrics: metrics, userMood: mood)
            }

            Task { @MainActor in
                // Actualiza store con métricas crudas para HomeDashboard
                self.store.update(from: breakdown, recommendation: recommendation, metrics: metrics)
            }

            completion(breakdown, recommendation)
        }
    }

    /// Pide una nueva recomendación rechazando la actual, sin re-fetch de métricas.
    /// Usado en el flujo 👎 para evitar espera y volver a ActionScreen rápido.
    func rejectAndFetchNext(
        current: Recommendation,
        completion: @escaping (Recommendation?) -> Void
    ) {
        recommendationPipeline.reject(current)
        let breakdown = store.breakdown
        let next = recommendationPipeline.requestRecommendation(
            physical:    breakdown.physical,
            mental:      breakdown.mental,
            mindfulness: breakdown.mindfulness
        )
        Task { @MainActor in
            self.store.update(from: breakdown, recommendation: next, metrics: self.lastMetrics ?? HealthMetrics(
                steps: 0, sleepHours: 0, exerciseMinutes: 0,
                screenTimeHours: 0, unlockCount: 0, productiveUsageRatio: 0,
                locationsVisited: 0, routineCompletionRatio: 0
            ))
        }
        completion(next)
    }

    func handleRecommendationAction(_ action: RecommendationAction, for recommendation: Recommendation) {
        switch action {
        case .reject:   recommendationPipeline.reject(recommendation)
        case .accept:   recommendationPipeline.accept(recommendation)
        case .complete: recommendationPipeline.complete(recommendation)
        }
    }

    // ======================================================
    // MARK: - MOOD FEEDBACK
    // ======================================================

    func submitMoodFeedback(score: Double) {
        guard let metrics = lastMetrics else {
            dataProvider.fetchMetrics { [weak self] metrics in
                guard let self else { return }
                self.lastMetrics = metrics
                self.applyFeedback(score: score, metrics: metrics)
            }
            return
        }
        applyFeedback(score: score, metrics: metrics)
    }

    private func applyFeedback(score: Double, metrics: HealthMetrics) {
        predictor.updateWeights(metrics: metrics, moodScore: score)
        trainer.recordDay(metrics: metrics, userMood: score)
        runDailyAnalysis()
    }

    // ======================================================
    // MARK: - ONBOARDING BOOTSTRAP
    // ======================================================

    func bootstrapAdaptivePredictor(with historicalMetrics: [HealthMetrics]) {
        predictor.bootstrapFromHistory(historicalMetrics)
    }

    // ======================================================
    // MARK: - DIAGNOSTICS
    // ======================================================

    func trainingDataPath() -> String { trainer.exportPath() }

    var adaptiveFeedbackCount: Int { predictor.feedbackCount }
    var isAdaptiveBootstrapped: Bool { predictor.isBootstrapped }
}
