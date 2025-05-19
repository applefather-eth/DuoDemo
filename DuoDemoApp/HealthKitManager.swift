import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var stepCount: Double = 0.0
    @Published var sleepSamples: [HKCategorySample] = []

    init() {
        requestAuthorization()
    }

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        healthStore.requestAuthorization(toShare: [], read: [stepType, sleepType]) { success, error in
            if success {
                self.fetchStepCount()
                self.fetchSleepData()
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

    func fetchSleepData() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        guard let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: startOfYesterday, end: startOfToday, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.sleepSamples = (samples as? [HKCategorySample]) ?? []
            }
        }
        healthStore.execute(query)
    }
} 