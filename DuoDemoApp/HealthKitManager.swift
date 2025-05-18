import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var stepCount: Double = 0.0

    init() {
        requestAuthorization()
    }

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if success {
                self.fetchStepCount()
            }
        }
    }

    func fetchStepCount() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.stepCount = sum.doubleValue(for: HKUnit.count())
                } else {
                    self.stepCount = 0
                }
            }
        }
        healthStore.execute(query)
    }
} 