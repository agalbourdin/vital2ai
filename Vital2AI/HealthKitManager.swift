import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()

    @Published var isAuthorized = false

    private let typesToRead: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
        HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
        HKObjectType.quantityType(forIdentifier: .vo2Max)!,
        HKObjectType.quantityType(forIdentifier: .heartRateRecoveryOneMinute)!,
        HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
        HKObjectType.quantityType(forIdentifier: .leanBodyMass)!,
        HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
        HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        HKObjectType.quantityType(forIdentifier: .timeInDaylight)!,
        HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
        HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!,
        HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)!,
        HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .walkingSpeed)!,
        HKObjectType.quantityType(forIdentifier: .walkingAsymmetryPercentage)!,
        HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!,
        HKObjectType.quantityType(forIdentifier: .walkingStepLength)!,
        HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!,
        HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!,
        HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!,
        HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFiber)!,
        HKObjectType.quantityType(forIdentifier: .dietarySugar)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCholesterol)!,
        HKObjectType.quantityType(forIdentifier: .dietarySodium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCalcium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryIron)!,
        HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryPotassium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryZinc)!,
        HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent)!,
        HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!,
        HKObjectType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
        HKObjectType.categoryType(forIdentifier: .lowCardioFitnessEvent)!,
        HKObjectType.quantityType(forIdentifier: .numberOfAlcoholicBeverages)!,
        HKObjectType.quantityType(forIdentifier: .atrialFibrillationBurden)!,
        HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
        HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
        HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
        HKObjectType.quantityType(forIdentifier: .distanceWheelchair)!,
        HKObjectType.quantityType(forIdentifier: .waistCircumference)!,
        HKObjectType.quantityType(forIdentifier: .peripheralPerfusionIndex)!,
        HKObjectType.quantityType(forIdentifier: .bloodGlucose)!,
        HKObjectType.quantityType(forIdentifier: .insulinDelivery)!,
        HKObjectType.quantityType(forIdentifier: .basalBodyTemperature)!,
        HKObjectType.quantityType(forIdentifier: .bodyTemperature)!,
        HKObjectType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!,
        HKObjectType.quantityType(forIdentifier: .forcedVitalCapacity)!,
        HKObjectType.quantityType(forIdentifier: .forcedExpiratoryVolume1)!,
        HKObjectType.electrocardiogramType(),
        HKObjectType.activitySummaryType(),
        HKObjectType.quantityType(forIdentifier: .height)!,
        HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
        HKObjectType.characteristicType(forIdentifier: .bloodType)!,
        HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!,
        HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!,
        // Symptoms
        HKObjectType.categoryType(forIdentifier: .abdominalCramps)!,
        HKObjectType.categoryType(forIdentifier: .acne)!,
        HKObjectType.categoryType(forIdentifier: .appetiteChanges)!,
        HKObjectType.categoryType(forIdentifier: .bladderIncontinence)!,
        HKObjectType.categoryType(forIdentifier: .bloating)!,
        HKObjectType.categoryType(forIdentifier: .breastPain)!,
        HKObjectType.categoryType(forIdentifier: .chestTightnessOrPain)!,
        HKObjectType.categoryType(forIdentifier: .chills)!,
        HKObjectType.categoryType(forIdentifier: .constipation)!,
        HKObjectType.categoryType(forIdentifier: .coughing)!,
        HKObjectType.categoryType(forIdentifier: .diarrhea)!,
        HKObjectType.categoryType(forIdentifier: .dizziness)!,
        HKObjectType.categoryType(forIdentifier: .drySkin)!,
        HKObjectType.categoryType(forIdentifier: .fainting)!,
        HKObjectType.categoryType(forIdentifier: .fatigue)!,
        HKObjectType.categoryType(forIdentifier: .fever)!,
        HKObjectType.categoryType(forIdentifier: .generalizedBodyAche)!,
        HKObjectType.categoryType(forIdentifier: .hairLoss)!,
        HKObjectType.categoryType(forIdentifier: .headache)!,
        HKObjectType.categoryType(forIdentifier: .heartburn)!,
        HKObjectType.categoryType(forIdentifier: .hotFlashes)!,
        HKObjectType.categoryType(forIdentifier: .lossOfSmell)!,
        HKObjectType.categoryType(forIdentifier: .lossOfTaste)!,
        HKObjectType.categoryType(forIdentifier: .lowerBackPain)!,
        HKObjectType.categoryType(forIdentifier: .memoryLapse)!,
        HKObjectType.categoryType(forIdentifier: .moodChanges)!,
        HKObjectType.categoryType(forIdentifier: .nausea)!,
        HKObjectType.categoryType(forIdentifier: .nightSweats)!,
        HKObjectType.categoryType(forIdentifier: .pelvicPain)!,
        HKObjectType.categoryType(forIdentifier: .rapidPoundingOrFlutteringHeartbeat)!,
        HKObjectType.categoryType(forIdentifier: .runnyNose)!,
        HKObjectType.categoryType(forIdentifier: .shortnessOfBreath)!,
        HKObjectType.categoryType(forIdentifier: .sinusCongestion)!,
        HKObjectType.categoryType(forIdentifier: .skippedHeartbeat)!,
        HKObjectType.categoryType(forIdentifier: .soreThroat)!,
        HKObjectType.categoryType(forIdentifier: .vaginalDryness)!,
        HKObjectType.categoryType(forIdentifier: .vomiting)!,
        HKObjectType.categoryType(forIdentifier: .wheezing)!,
        HKObjectType.categoryType(forIdentifier: .sleepChanges)!,
        HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
        HKObjectType.quantityType(forIdentifier: .appleWalkingSteadiness)!,
        HKObjectType.quantityType(forIdentifier: .sixMinuteWalkTestDistance)!,
        HKObjectType.quantityType(forIdentifier: .uvExposure)!,
        HKObjectType.quantityType(forIdentifier: .electrodermalActivity)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFolate)!,
        HKObjectType.quantityType(forIdentifier: .dietaryBiotin)!,
        HKObjectType.quantityType(forIdentifier: .dietarySelenium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryIodine)!,
        HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!,
        HKObjectType.quantityType(forIdentifier: .numberOfTimesFallen)!,
        HKSeriesType.heartbeat(),
        HKObjectType.workoutType()
    ]

    // Use a computed property for types that might not be available on all iOS versions
    private var allTypesToRead: Set<HKObjectType> {
        var types = typesToRead
        if #available(iOS 17.0, *) {
            types.insert(HKObjectType.stateOfMindType())
        }
        if #available(iOS 18.0, *) {
            if let effort = HKQuantityType.quantityType(forIdentifier: .workoutEffortScore) {
                types.insert(effort)
            }
            if let estimatedEffort = HKQuantityType.quantityType(forIdentifier: .estimatedWorkoutEffortScore) {
                types.insert(estimatedEffort)
            }
            if let breathing = HKQuantityType.quantityType(forIdentifier: .appleSleepingBreathingDisturbances) {
                types.insert(breathing)
            }
        }
        return types
    }

    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "com.applehealth.export", code: 1, userInfo: [NSLocalizedDescriptionKey: String(localized: "error_healthkit_not_available")])
        }

        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: allTypesToRead) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    DispatchQueue.main.async {
                        self.isAuthorized = success
                    }
                    continuation.resume(returning: success)
                }
            }
        }
    }

    private struct QuantityMetric: Sendable {
        let identifier: HKQuantityTypeIdentifier
        let unit: HKUnit
        let setter: @Sendable (inout DailySummary, Double) -> Void
    }

    private nonisolated static let activityMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .stepCount, unit: .count(), setter: { $0.stepCount = $1 }),
        QuantityMetric(identifier: .distanceWalkingRunning, unit: .meterUnit(with: .kilo), setter: { $0.distanceWalkingRunning = $1 }),
        QuantityMetric(identifier: .flightsClimbed, unit: .count(), setter: { $0.flightsClimbed = $1 }),
        QuantityMetric(identifier: .appleExerciseTime, unit: .minute(), setter: { $0.appleExerciseTime = $1 }),
        QuantityMetric(identifier: .activeEnergyBurned, unit: .kilocalorie(), setter: { $0.activeEnergyBurned = $1 }),
        QuantityMetric(identifier: .distanceCycling, unit: .meterUnit(with: .kilo), setter: { $0.distanceCycling = $1 > 0 ? $1 : nil }),
        QuantityMetric(identifier: .distanceSwimming, unit: .meter(), setter: { $0.swimmingDistance = $1 }),
        QuantityMetric(identifier: .distanceWheelchair, unit: .meter(), setter: { $0.wheelchairDistance = $1 }),
        QuantityMetric(identifier: .appleStandTime, unit: .minute(), setter: { $0.appleStandTime = $1 }),
        QuantityMetric(identifier: .basalEnergyBurned, unit: .kilocalorie(), setter: { $0.basalEnergyBurned = $1 })
    ]

    private nonisolated static let bodyMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .bodyMass, unit: .gramUnit(with: .kilo), setter: { $0.bodyMass = $1 }),
        QuantityMetric(identifier: .bodyMassIndex, unit: .count(), setter: { $0.bodyMassIndex = $1 }),
        QuantityMetric(identifier: .bodyFatPercentage, unit: .percent(), setter: { $0.bodyFatPercentage = $1 }),
        QuantityMetric(identifier: .leanBodyMass, unit: .gramUnit(with: .kilo), setter: { $0.leanBodyMass = $1 }),
        QuantityMetric(identifier: .waistCircumference, unit: .meterUnit(with: .centi), setter: { $0.waistCircumference = $1 })
    ]

    private nonisolated static let vitalsMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .heartRate, unit: HKUnit(from: "count/min"), setter: { $0.heartRate = $1 }),
        QuantityMetric(identifier: .restingHeartRate, unit: HKUnit(from: "count/min"), setter: { $0.restingHeartRate = $1 }),
        QuantityMetric(identifier: .heartRateVariabilitySDNN, unit: .secondUnit(with: .milli), setter: { $0.heartRateVariabilitySDNN = $1 }),
        QuantityMetric(identifier: .oxygenSaturation, unit: .percent(), setter: { $0.oxygenSaturation = $1 }),
        QuantityMetric(identifier: .walkingHeartRateAverage, unit: HKUnit(from: "count/min"), setter: { $0.walkingHeartRateAverage = $1 }),
        QuantityMetric(identifier: .vo2Max, unit: HKUnit(from: "ml/kg*min"), setter: { $0.vo2Max = $1 }),
        QuantityMetric(identifier: .heartRateRecoveryOneMinute, unit: HKUnit(from: "count/min"), setter: { $0.heartRateRecoveryOneMinute = $1 }),
        QuantityMetric(identifier: .respiratoryRate, unit: HKUnit(from: "count/min"), setter: { $0.respiratoryRate = $1 }),
        QuantityMetric(identifier: .bloodPressureSystolic, unit: .millimeterOfMercury(), setter: { $0.bloodPressureSystolic = $1 }),
        QuantityMetric(identifier: .bloodPressureDiastolic, unit: .millimeterOfMercury(), setter: { $0.bloodPressureDiastolic = $1 }),
        QuantityMetric(identifier: .appleSleepingWristTemperature, unit: .degreeCelsius(), setter: { $0.appleSleepingWristTemperature = $1 }),
        QuantityMetric(identifier: .basalBodyTemperature, unit: .degreeCelsius(), setter: { $0.basalBodyTemperature = $1 }),
        QuantityMetric(identifier: .bodyTemperature, unit: .degreeCelsius(), setter: { $0.bodyTemperature = $1 }),
        QuantityMetric(identifier: .bloodGlucose, unit: HKUnit(from: "mg/dL"), setter: { $0.bloodGlucose = $1 }),
        QuantityMetric(identifier: .insulinDelivery, unit: .internationalUnit(), setter: { $0.insulinDelivery = $1 })
    ]

    private nonisolated static let nutritionMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .dietaryEnergyConsumed, unit: .kilocalorie(), setter: { $0.dietaryEnergyConsumed = $1 }),
        QuantityMetric(identifier: .dietaryProtein, unit: .gram(), setter: { $0.dietaryProtein = $1 }),
        QuantityMetric(identifier: .dietaryCarbohydrates, unit: .gram(), setter: { $0.dietaryCarbohydrates = $1 }),
        QuantityMetric(identifier: .dietaryFatTotal, unit: .gram(), setter: { $0.dietaryFatTotal = $1 }),
        QuantityMetric(identifier: .dietaryFatSaturated, unit: .gram(), setter: { $0.dietaryFatSaturated = $1 }),
        QuantityMetric(identifier: .dietaryFatMonounsaturated, unit: .gram(), setter: { $0.dietaryFatMonounsaturated = $1 }),
        QuantityMetric(identifier: .dietaryFatPolyunsaturated, unit: .gram(), setter: { $0.dietaryFatPolyunsaturated = $1 }),
        QuantityMetric(identifier: .dietaryFiber, unit: .gram(), setter: { $0.dietaryFiber = $1 }),
        QuantityMetric(identifier: .dietarySugar, unit: .gram(), setter: { $0.dietarySugar = $1 }),
        QuantityMetric(identifier: .dietaryCholesterol, unit: .gramUnit(with: .milli), setter: { $0.dietaryCholesterol = $1 }),
        QuantityMetric(identifier: .dietarySodium, unit: .gramUnit(with: .milli), setter: { $0.dietarySodium = $1 }),
        QuantityMetric(identifier: .dietaryWater, unit: .literUnit(with: .milli), setter: { $0.waterIntake = $1 }),
        QuantityMetric(identifier: .dietaryCaffeine, unit: .gramUnit(with: .milli), setter: { $0.dietaryCaffeine = $1 }),
        QuantityMetric(identifier: .numberOfAlcoholicBeverages, unit: .count(), setter: { $0.numberOfAlcoholicBeverages = $1 })
    ]

    private nonisolated static let vitaminMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .dietaryVitaminA, unit: .gramUnit(with: .micro), setter: { $0.dietaryVitaminA = $1 }),
        QuantityMetric(identifier: .dietaryVitaminB6, unit: .gramUnit(with: .milli), setter: { $0.dietaryVitaminB6 = $1 }),
        QuantityMetric(identifier: .dietaryVitaminB12, unit: .gramUnit(with: .micro), setter: { $0.dietaryVitaminB12 = $1 }),
        QuantityMetric(identifier: .dietaryVitaminC, unit: .gramUnit(with: .milli), setter: { $0.dietaryVitaminC = $1 }),
        QuantityMetric(identifier: .dietaryVitaminD, unit: .gramUnit(with: .micro), setter: { $0.dietaryVitaminD = $1 }),
        QuantityMetric(identifier: .dietaryVitaminE, unit: .gramUnit(with: .milli), setter: { $0.dietaryVitaminE = $1 }),
        QuantityMetric(identifier: .dietaryVitaminK, unit: .gramUnit(with: .micro), setter: { $0.dietaryVitaminK = $1 }),
        QuantityMetric(identifier: .dietaryFolate, unit: .gramUnit(with: .micro), setter: { $0.dietaryFolate = $1 }),
        QuantityMetric(identifier: .dietaryBiotin, unit: .gramUnit(with: .micro), setter: { $0.dietaryBiotin = $1 }),
        QuantityMetric(identifier: .dietaryCalcium, unit: .gramUnit(with: .milli), setter: { $0.dietaryCalcium = $1 }),
        QuantityMetric(identifier: .dietaryIron, unit: .gramUnit(with: .milli), setter: { $0.dietaryIron = $1 }),
        QuantityMetric(identifier: .dietaryMagnesium, unit: .gramUnit(with: .milli), setter: { $0.dietaryMagnesium = $1 }),
        QuantityMetric(identifier: .dietaryPotassium, unit: .gramUnit(with: .milli), setter: { $0.dietaryPotassium = $1 }),
        QuantityMetric(identifier: .dietaryZinc, unit: .gramUnit(with: .milli), setter: { $0.dietaryZinc = $1 }),
        QuantityMetric(identifier: .dietarySelenium, unit: .gramUnit(with: .micro), setter: { $0.dietarySelenium = $1 }),
        QuantityMetric(identifier: .dietaryIodine, unit: .gramUnit(with: .micro), setter: { $0.dietaryIodine = $1 })
    ]

    private nonisolated static let mobilityMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .walkingSpeed, unit: HKUnit.meterUnit(with: .kilo).unitDivided(by: .hour()), setter: { $0.walkingSpeed = $1 }),
        QuantityMetric(identifier: .walkingAsymmetryPercentage, unit: .percent(), setter: { $0.walkingAsymmetryPercentage = $1 > 0 ? $1 * 100 : nil }),
        QuantityMetric(identifier: .walkingDoubleSupportPercentage, unit: .percent(), setter: { $0.walkingDoubleSupportPercentage = $1 > 0 ? $1 * 100 : nil }),
        QuantityMetric(identifier: .walkingStepLength, unit: .meterUnit(with: .centi), setter: { $0.walkingStepLength = $1 }),
        QuantityMetric(identifier: .stairAscentSpeed, unit: HKUnit.meterUnit(with: .none).unitDivided(by: .second()), setter: { $0.stairAscentSpeed = $1 }),
        QuantityMetric(identifier: .stairDescentSpeed, unit: HKUnit.meterUnit(with: .none).unitDivided(by: .second()), setter: { $0.stairDescentSpeed = $1 }),
        QuantityMetric(identifier: .appleWalkingSteadiness, unit: .percent(), setter: { $0.walkingSteadiness = $1 * 100 }),
        QuantityMetric(identifier: .sixMinuteWalkTestDistance, unit: .meter(), setter: { $0.sixMinuteWalkDistance = $1 })
    ]


    private nonisolated static let otherMetrics: [QuantityMetric] = [
        QuantityMetric(identifier: .timeInDaylight, unit: .minute(), setter: { $0.timeInDaylight = $1 }),
        QuantityMetric(identifier: .environmentalAudioExposure, unit: .decibelAWeightedSoundPressureLevel(), setter: { $0.environmentalAudioExposure = $1 }),
        QuantityMetric(identifier: .headphoneAudioExposure, unit: .decibelAWeightedSoundPressureLevel(), setter: { $0.headphoneAudioExposure = $1 }),
        QuantityMetric(identifier: .uvExposure, unit: .count(), setter: { $0.uvExposure = $1 }),
        QuantityMetric(identifier: .electrodermalActivity, unit: HKUnit.siemen(), setter: { $0.electrodermalActivity = $1 }),
        QuantityMetric(identifier: .numberOfTimesFallen, unit: .count(), setter: { $0.falls = $1 }),
        QuantityMetric(identifier: .peakExpiratoryFlowRate, unit: HKUnit(from: "L/min"), setter: { $0.peakExpiratoryFlowRate = $1 }),
        QuantityMetric(identifier: .forcedVitalCapacity, unit: .liter(), setter: { $0.forcedVitalCapacity = $1 }),
        QuantityMetric(identifier: .forcedExpiratoryVolume1, unit: .liter(), setter: { $0.forcedExpiratoryVolume = $1 })
    ]

    private nonisolated static var allQuantityMetrics: [QuantityMetric] {
        activityMetrics + bodyMetrics + vitalsMetrics + nutritionMetrics + vitaminMetrics + mobilityMetrics + otherMetrics
    }

    private enum FetchResult: Sendable {
        case quantity(QuantityMetric, [Date: Double])
        case breathingDisturbances([Date: Double])
        case atrialFibrillationBurden([Date: Double])
        case standHours([Date: Int])
        case sleep([Date: (total: Double, core: Double, deep: Double, rem: Double, awake: Double, awakenings: Int, start: Date?)])
        case categoryEvent(HKCategoryTypeIdentifier, [Date: Int])
        case calculatedHeartRateDecelerationIndex([Date: Double])
        case ecg([Date: (count: Int, afibCount: Int, avgHeartRate: Double?, classifications: String)])
        case mindfulMinutes([Date: Double])
        case stateOfMind([Date: Double])
        case activity([Date: (activeEnergyBurnedGoal: Double?, exerciseTimeGoal: Double?, standHoursGoal: Double?)])
        case symptoms([Date: String])
    }

    func fetchDailySummaries(for months: [ExportMonth]) async -> [DailySummary] {
        let calendar = Calendar.current
        guard !months.isEmpty else { return [] }

        var summariesDict: [Date: DailySummary] = [:]
        let startOfToday = calendar.startOfDay(for: Date())

        for month in months {
            var currentDate = month.date
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: month.date)!
            while currentDate < nextMonth && currentDate < startOfToday {
                summariesDict[currentDate] = DailySummary(date: currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        }

        // Helper to process a set of fetch results in the summariesDict
        func applyResult(_ result: FetchResult) {
            switch result {
            case .quantity(let metric, let stats):
                for (date, value) in stats {
                    if var summary = summariesDict[date] {
                        metric.setter(&summary, value)
                        summariesDict[date] = summary
                    }
                }

            case .breathingDisturbances(let stats):
                for (date, value) in stats {
                    if var summary = summariesDict[date] {
                        summary.breathingDisturbances = value
                        summariesDict[date] = summary
                    }
                }

            case .atrialFibrillationBurden(let stats):
                let sortedSummaryDates = summariesDict.keys.sorted()
                let sortedAFBDates = stats.keys.sorted()
                var currentAFB: Double? = nil

                if let firstDate = sortedSummaryDates.first {
                    currentAFB = sortedAFBDates.filter { $0 <= firstDate }.last.flatMap { stats[$0] }
                }

                for date in sortedSummaryDates {
                    if let newValue = stats[date] { currentAFB = newValue }
                    if let val = currentAFB, var summary = summariesDict[date] {
                        summary.atrialFibrillationBurden = Int((val * 100).rounded())
                        summariesDict[date] = summary
                    }
                }

            case .standHours(let standStats):
                for (date, count) in standStats {
                    if var summary = summariesDict[date] {
                        summary.appleStandHour = Double(count)
                        summariesDict[date] = summary
                    }
                }

            case .sleep(let sleepStats):
                for (date, stats) in sleepStats {
                    if var summary = summariesDict[date] {
                        summary.sleepAnalysis = stats.total
                        summary.sleepCore = stats.core
                        summary.sleepDeep = stats.deep
                        summary.sleepREM = stats.rem
                        summary.sleepStart = stats.start
                        summary.awakeDuringSleep = stats.awake
                        summary.awakeningsCount = stats.awakenings
                        summariesDict[date] = summary
                    }
                }

            case .categoryEvent(let identifier, let eventStats):
                for (date, count) in eventStats {
                    if var summary = summariesDict[date] {
                        switch identifier {
                        case .lowHeartRateEvent: summary.lowHeartRateEvent = count
                        case .highHeartRateEvent: summary.highHeartRateEvent = count
                        case .irregularHeartRhythmEvent: summary.irregularHeartRhythmEvent = count
                        case .lowCardioFitnessEvent: summary.lowCardioFitnessEvent = count
                        default: break
                        }
                        summariesDict[date] = summary
                    }
                }

            case .calculatedHeartRateDecelerationIndex(let dcStats):
                for (date, dc) in dcStats {
                    if var summary = summariesDict[date] {
                        summary.calculatedHeartRateDecelerationIndex = dc
                        summariesDict[date] = summary
                    }
                }

            case .ecg(let ecgStats):
                for (date, data) in ecgStats {
                    if var summary = summariesDict[date] {
                        summary.electrocardiogramCount = data.count
                        summary.electrocardiogramAtrialFibrillationCount = data.afibCount
                        summary.electrocardiogramAverageHeartRate = data.avgHeartRate
                        summary.electrocardiogramClassification = data.classifications
                        summariesDict[date] = summary
                    }
                }

            case .mindfulMinutes(let mindfulStats):
                for (date, minutes) in mindfulStats {
                    if var summary = summariesDict[date] {
                        summary.mindfulMinutes = minutes
                        summariesDict[date] = summary
                    }
                }

            case .stateOfMind(let somStats):
                for (date, valence) in somStats {
                    if var summary = summariesDict[date] {
                        summary.averageStateOfMindValence = valence
                        summariesDict[date] = summary
                    }
                }

            case .activity(let activityStats):
                for (date, data) in activityStats {
                    if var summary = summariesDict[date] {
                        summary.activeEnergyBurnedGoal = data.activeEnergyBurnedGoal
                        summary.exerciseTimeGoal = data.exerciseTimeGoal
                        summary.standHoursGoal = data.standHoursGoal

                        let standCompleted = (summary.appleStandHour ?? 0) >= (data.standHoursGoal ?? Double.greatestFiniteMagnitude)
                        let energyCompleted = (summary.activeEnergyBurned ?? 0) >= (data.activeEnergyBurnedGoal ?? Double.greatestFiniteMagnitude)
                        let exerciseCompleted = (summary.appleExerciseTime ?? 0) >= (data.exerciseTimeGoal ?? Double.greatestFiniteMagnitude)

                        if data.standHoursGoal != nil && data.activeEnergyBurnedGoal != nil && data.exerciseTimeGoal != nil {
                            summary.appleRingsCompleted = (standCompleted && energyCompleted && exerciseCompleted) ? 1 : 0
                        } else {
                            summary.appleRingsCompleted = 0
                        }
                        summariesDict[date] = summary
                    }
                }

            case .symptoms(let symptomStats):
                for (date, symptoms) in symptomStats {
                    if var summary = summariesDict[date] {
                        summary.symptoms = symptoms
                        summariesDict[date] = summary
                    }
                }
            }
        }

        // We process metrics in batches to avoid overwhelming HealthKit
        let quantityMetrics = Self.allQuantityMetrics
        let batchSize = 15

        for i in stride(from: 0, to: quantityMetrics.count, by: batchSize) {
            let endBatch = min(i + batchSize, quantityMetrics.count)
            let batch = Array(quantityMetrics[i..<endBatch])

            await withTaskGroup(of: FetchResult.self) { group in
                for metric in batch {
                    let m = metric
                    group.addTask {
                        let stats = await self.fetchQuantityStats(for: m.identifier, unit: m.unit, months: months)
                        return .quantity(m, stats)
                    }
                }
                for await result in group { applyResult(result) }
            }
        }

        // Fetch "special" metrics in another batch
        await withTaskGroup(of: FetchResult.self) { group in
            if #available(iOS 18.0, *) {
                group.addTask {
                    let stats = await self.fetchQuantityStats(for: .appleSleepingBreathingDisturbances, unit: .count(), months: months)
                    return .breathingDisturbances(stats)
                }
            }

            group.addTask {
                let stats = await self.fetchQuantityStats(for: .atrialFibrillationBurden, unit: .percent(), months: months, includeEarlierDataForFillForward: true)
                return .atrialFibrillationBurden(stats)
            }

            group.addTask {
                let standStats = await self.fetchStandHours(months: months)
                return .standHours(standStats)
            }

            group.addTask {
                let sleepStats = await self.fetchSleepData(months: months)
                return .sleep(sleepStats)
            }

            let eventTypes: [HKCategoryTypeIdentifier] = [.lowHeartRateEvent, .highHeartRateEvent, .irregularHeartRhythmEvent, .lowCardioFitnessEvent]
            for identifier in eventTypes {
                let id = identifier
                group.addTask {
                    let eventStats = await self.fetchCategoryEvents(for: id, months: months)
                    return .categoryEvent(id, eventStats)
                }
            }

            group.addTask {
                let ecgStats = await self.fetchECGData(months: months)
                return .ecg(ecgStats)
            }

            group.addTask {
                let mindfulStats = await self.fetchMindfulMinutes(months: months)
                return .mindfulMinutes(mindfulStats)
            }

            if #available(iOS 17.0, *) {
                group.addTask {
                    let somStats = await self.fetchStateOfMind(months: months)
                    return .stateOfMind(somStats)
                }
            }

            group.addTask {
                let activityStats = await self.fetchActivitySummaries(months: months)
                return .activity(activityStats)
            }

            group.addTask {
                let symptomStats = await self.fetchSymptoms(months: months)
                return .symptoms(symptomStats)
            }

            group.addTask {
                let dcStats = await self.fetchCalculatedHeartRateDecelerationIndex(months: months)
                return .calculatedHeartRateDecelerationIndex(dcStats)
            }

            for await result in group { applyResult(result) }
        }

        let sortedSummaries = summariesDict.keys.sorted().map { summariesDict[$0]! }
        return sortedSummaries.map { summary in
            var s = summary
            if let active = s.activeEnergyBurned, let basal = s.basalEnergyBurned {
                s.dailyCalories = active + basal
            }
            return s
        }
    }

    nonisolated private func fetchQuantityStats(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, months: [ExportMonth], includeEarlierDataForFillForward: Bool = false) async -> [Date: Double] {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier), let firstMonth = months.first, let lastMonth = months.last else { return [:] }

        var options: HKStatisticsOptions = []
        if type.aggregationStyle == .cumulative {
            options = [.cumulativeSum]
        } else {
            options = [.discreteAverage, .discreteMax, .discreteMin, .mostRecent]
        }

        // Specific overrides for consistency
        if identifier == .heartRate || identifier == .oxygenSaturation || identifier == .restingHeartRate {
            options = [.discreteAverage]
        }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let queryStart = includeEarlierDataForFillForward ? calendar.date(byAdding: .day, value: -7, to: start)! : start
        let interval = DateComponents(day: 1)

        let predicate = HKQuery.predicateForSamples(withStart: queryStart, end: end, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: options, anchorDate: start, intervalComponents: interval)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            query.initialResultsHandler = { _, results, error in
                if isCompleted.getAndSet(true) { return }

                var stats: [Date: Double] = [:]
                results?.enumerateStatistics(from: queryStart, to: end) { statistics, _ in
                    let value: Double?
                    if type.aggregationStyle == .cumulative {
                        value = statistics.sumQuantity()?.doubleValue(for: unit)
                    } else {
                        value = statistics.averageQuantity()?.doubleValue(for: unit) ?? statistics.mostRecentQuantity()?.doubleValue(for: unit)
                    }
                    if let val = value {
                        stats[calendar.startOfDay(for: statistics.startDate)] = val
                    }
                }
                continuation.resume(returning: stats)
            }

            // Increased timeout for larger ranges
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) {
                    continuation.resume(returning: [:])
                }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchStandHours(months: [ExportMonth]) async -> [Date: Int] {
        guard let standType = HKObjectType.categoryType(forIdentifier: .appleStandHour),
              let firstMonth = months.first,
              let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: standType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }

                var standStats: [Date: Set<Int>] = [:]
                if let standSamples = samples as? [HKCategorySample] {
                    for sample in standSamples {
                        if sample.value == HKCategoryValueAppleStandHour.stood.rawValue {
                            let day = calendar.startOfDay(for: sample.startDate)
                            let hour = calendar.component(.hour, from: sample.startDate)
                            standStats[day, default: []].insert(hour)
                        }
                    }
                }
                continuation.resume(returning: standStats.mapValues { $0.count })
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) {
                    continuation.resume(returning: [:])
                }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchCategoryEvents(for identifier: HKCategoryTypeIdentifier, months: [ExportMonth]) async -> [Date: Int] {
        guard let type = HKObjectType.categoryType(forIdentifier: identifier),
              let firstMonth = months.first,
              let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }

                var eventStats: [Date: Int] = [:]
                if let eventSamples = samples as? [HKCategorySample] {
                    for sample in eventSamples {
                        let day = calendar.startOfDay(for: sample.startDate)
                        eventStats[day, default: 0] += 1
                    }
                }
                continuation.resume(returning: eventStats)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) {
                    continuation.resume(returning: [:])
                }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchSleepData(months: [ExportMonth]) async -> [Date: (total: Double, core: Double, deep: Double, rem: Double, awake: Double, awakenings: Int, start: Date?)] {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              let firstMonth = months.first,
              let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let startRange = firstMonth.date
        let endRange = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let fetchStart = calendar.date(byAdding: .day, value: -2, to: startRange)!
        let predicate = HKQuery.predicateForSamples(withStart: fetchStart, end: endRange, options: [])

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }

                guard let allSamples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: [:])
                    return
                }

                let healthSamples = allSamples.filter { $0.sourceRevision.source.bundleIdentifier.starts(with: "com.apple.health") }
                var allStats: [Date: (total: Double, core: Double, deep: Double, rem: Double, awake: Double, awakenings: Int, start: Date?)] = [:]

                for month in months {
                    var currentDate = month.date
                    let monthEnd = calendar.date(byAdding: .month, value: 1, to: currentDate)!

                    while currentDate < monthEnd {
                        let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate)!
                        let windowStart = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: previousDay)!
                        let windowEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: currentDate)!

                        let nightSamples = healthSamples.filter { $0.startDate >= windowStart && $0.startDate < windowEnd }

                        var remSec: TimeInterval = 0
                        var deepSec: TimeInterval = 0
                        var coreSec: TimeInterval = 0
                        var awakeSec: TimeInterval = 0
                        var awakenings = 0

                        for sample in nightSamples {
                            let dur = sample.endDate.timeIntervalSince(sample.startDate)
                            switch sample.value {
                            case HKCategoryValueSleepAnalysis.asleepREM.rawValue: remSec += dur
                            case HKCategoryValueSleepAnalysis.asleepCore.rawValue: coreSec += dur
                            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue: deepSec += dur
                            case HKCategoryValueSleepAnalysis.awake.rawValue: awakeSec += dur; awakenings += 1
                            default: break
                            }
                        }

                        let totalSec = remSec + deepSec + coreSec
                        if totalSec > 0 {
                            allStats[currentDate] = (
                                total: totalSec / 3600.0,
                                core: coreSec / 3600.0,
                                deep: deepSec / 3600.0,
                                rem: remSec / 3600.0,
                                awake: awakeSec / 3600.0,
                                awakenings: awakenings,
                                start: nightSamples.map { $0.startDate }.min()
                            )
                        }
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                    }
                }
                continuation.resume(returning: allStats)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) {
                    continuation.resume(returning: [:])
                }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchECGData(months: [ExportMonth]) async -> [Date: (count: Int, afibCount: Int, avgHeartRate: Double?, classifications: String)] {
        let ecgType = HKObjectType.electrocardiogramType()
        guard let firstMonth = months.first, let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: ecgType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }

                var stats: [Date: (count: Int, afibCount: Int, heartRates: [Double], classifications: Set<String>)] = [:]
                if let ecgs = samples as? [HKElectrocardiogram] {
                    for ecg in ecgs {
                        let day = calendar.startOfDay(for: ecg.startDate)
                        var current = stats[day] ?? (0, 0, [], [])
                        current.count += 1
                        if ecg.classification == .atrialFibrillation { current.afibCount += 1 }
                        if let hr = ecg.averageHeartRate?.doubleValue(for: HKUnit(from: "count/min")) {
                            current.heartRates.append(hr)
                        }
                        current.classifications.insert(ecg.classification.name)
                        stats[day] = current
                    }
                }

                let result = stats.mapValues { s in
                    let avgHR = s.heartRates.isEmpty ? nil : s.heartRates.reduce(0, +) / Double(s.heartRates.count)
                    let classStr = s.classifications.joined(separator: ";")
                    return (s.count, s.afibCount, avgHR, classStr)
                }
                continuation.resume(returning: result)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) {
                    continuation.resume(returning: [:])
                }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchActivitySummaries(months: [ExportMonth]) async -> [Date: (activeEnergyBurnedGoal: Double?, exerciseTimeGoal: Double?, standHoursGoal: Double?)] {
        guard let firstMonth = months.first, let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let startRange = firstMonth.date
        let endRange = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!

        var startComponents = calendar.dateComponents([.day, .month, .year], from: startRange)
        startComponents.calendar = calendar
        var endComponents = calendar.dateComponents([.day, .month, .year], from: endRange)
        endComponents.calendar = calendar
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, error in
                if isCompleted.getAndSet(true) { return }

                var stats: [Date: (activeEnergyBurnedGoal: Double?, exerciseTimeGoal: Double?, standHoursGoal: Double?)] = [:]
                if let activitySummaries = summaries, error == nil {
                    for summary in activitySummaries {
                        if let date = summary.dateComponents(for: calendar).date {
                            let day = calendar.startOfDay(for: date)
                            let energyGoal = summary.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
                            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: .minute())
                            let standGoal = summary.appleStandHoursGoal.doubleValue(for: .count())

                            stats[day] = (
                                activeEnergyBurnedGoal: energyGoal > 0 ? energyGoal : nil,
                                exerciseTimeGoal: exerciseGoal > 0 ? exerciseGoal : nil,
                                standHoursGoal: standGoal > 0 ? standGoal : nil
                            )
                        }
                    }
                }
                continuation.resume(returning: stats)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) { continuation.resume(returning: [:]) }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchSymptoms(months: [ExportMonth]) async -> [Date: String] {
        let symptomIdentifiers: [HKCategoryTypeIdentifier] = [
            .abdominalCramps, .acne, .appetiteChanges, .bladderIncontinence, .bloating,
            .breastPain, .chestTightnessOrPain, .chills, .constipation, .coughing,
            .diarrhea, .dizziness, .drySkin, .fainting, .fatigue, .fever,
            .generalizedBodyAche, .hairLoss, .headache, .heartburn, .hotFlashes,
            .lossOfSmell, .lossOfTaste, .lowerBackPain, .memoryLapse, .moodChanges,
            .nausea, .nightSweats, .pelvicPain, .rapidPoundingOrFlutteringHeartbeat,
            .runnyNose, .shortnessOfBreath, .sinusCongestion, .skippedHeartbeat,
            .soreThroat, .vaginalDryness, .vomiting, .wheezing, .sleepChanges
        ]

        guard let firstMonth = months.first, let lastMonth = months.last else { return [:] }
        let calendar = Calendar.current
        let startRange = firstMonth.date
        let endRange = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: startRange, end: endRange, options: .strictStartDate)

        var allSymptomData: [Date: Set<String>] = [:]

        await withTaskGroup(of: [Date: Set<String>].self) { group in
            for identifier in symptomIdentifiers {
                group.addTask {
                    guard let type = HKObjectType.categoryType(forIdentifier: identifier) else { return [:] }

                    return await withCheckedContinuation { continuation in
                        let isCompleted = AtomicBool()
                        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                            if isCompleted.getAndSet(true) { return }

                            var stats: [Date: Set<String>] = [:]
                            if let samples = samples as? [HKCategorySample] {
                                for sample in samples {
                                    let day = calendar.startOfDay(for: sample.startDate)
                                    let symptomName = self.formatSymptomName(identifier.rawValue)
                                    stats[day, default: []].insert(symptomName)
                                }
                            }
                            continuation.resume(returning: stats)
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                            if !isCompleted.getAndSet(true) { continuation.resume(returning: [:]) }
                        }
                        self.healthStore.execute(query)
                    }
                }
            }

            for await result in group {
                for (date, symptoms) in result {
                    allSymptomData[date, default: []].formUnion(symptoms)
                }
            }
        }

        return allSymptomData.mapValues { $0.sorted().joined(separator: ";") }
    }

    func fetchMedicalID() async -> MedicalID {
        var medicalID = MedicalID()

        // 1. Characteristics
        do {
            if let dob = try healthStore.dateOfBirthComponents().date {
                let ageComponents = Calendar.current.dateComponents([.year], from: dob, to: Date())
                medicalID.age = ageComponents.year
            }
        } catch {}

        do {
            let sex = try healthStore.biologicalSex().biologicalSex
            switch sex {
            case .female: medicalID.biologicalSex = "Female"
            case .male: medicalID.biologicalSex = "Male"
            case .other: medicalID.biologicalSex = "Other"
            case .notSet: medicalID.biologicalSex = "Not Set"
            @unknown default: break
            }
        } catch {}

        do {
            let bloodType = try healthStore.bloodType().bloodType
            switch bloodType {
            case .aPositive: medicalID.bloodType = "A+"
            case .aNegative: medicalID.bloodType = "A-"
            case .bPositive: medicalID.bloodType = "B+"
            case .bNegative: medicalID.bloodType = "B-"
            case .abPositive: medicalID.bloodType = "AB+"
            case .abNegative: medicalID.bloodType = "AB-"
            case .oPositive: medicalID.bloodType = "O+"
            case .oNegative: medicalID.bloodType = "O-"
            case .notSet: medicalID.bloodType = "Not Set"
            @unknown default: break
            }
        } catch {}

        do {
            let skinType = try healthStore.fitzpatrickSkinType().skinType
            switch skinType {
            case .I: medicalID.fitzpatrickSkinType = "Type I"
            case .II: medicalID.fitzpatrickSkinType = "Type II"
            case .III: medicalID.fitzpatrickSkinType = "Type III"
            case .IV: medicalID.fitzpatrickSkinType = "Type IV"
            case .V: medicalID.fitzpatrickSkinType = "Type V"
            case .VI: medicalID.fitzpatrickSkinType = "Type VI"
            case .notSet: medicalID.fitzpatrickSkinType = "Not Set"
            @unknown default: break
            }
        } catch {}

        do {
            let wheelchair = try healthStore.wheelchairUse().wheelchairUse
            switch wheelchair {
            case .no: medicalID.wheelchairUse = "No"
            case .yes: medicalID.wheelchairUse = "Yes"
            case .notSet: medicalID.wheelchairUse = "Not Set"
            @unknown default: break
            }
        } catch {}

        // 2. Latest Height and Weight
        medicalID.height = await fetchLatestQuantity(for: .height, unit: .meterUnit(with: .centi))
        medicalID.bodyMass = await fetchLatestQuantity(for: .bodyMass, unit: .gramUnit(with: .kilo))

        return medicalID
    }

    func fetchWorkouts(for months: [ExportMonth], medicalID: MedicalID) async -> [WorkoutSummary] {
        let calendar = Calendar.current
        guard let firstMonth = months.first, let lastMonth = months.last else { return [] }

        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let allWorkouts: [HKWorkout] = await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }
                continuation.resume(returning: (samples as? [HKWorkout]) ?? [])
            }

            // Increased timeout for 15 months range
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) { continuation.resume(returning: []) }
            }
            self.healthStore.execute(query)
        }

        let age = medicalID.age ?? 30
        let maxHR = Double(220 - age)
        let zThresholds = (z1: maxHR * 0.50, z2: maxHR * 0.60, z3: maxHR * 0.70, z4: maxHR * 0.80, z5: maxHR * 0.90)

        var workoutSummaries: [WorkoutSummary] = []

        // Process workouts in batches to avoid overwhelming HealthKit with queries
        let batchSize = 10
        for i in stride(from: 0, to: allWorkouts.count, by: batchSize) {
            let endBatch = min(i + batchSize, allWorkouts.count)
            let batch = Array(allWorkouts[i..<endBatch])

            await withTaskGroup(of: WorkoutSummary.self) { group in
                for workout in batch {
                    group.addTask {
                        let hrStats = await self.fetchWorkoutHeartRateData(workout: workout, thresholds: zThresholds)
                        let hrr = await self.fetchWorkoutHeartRateRecovery(workout: workout)
                        let effort = await self.fetchWorkoutEffortScore(workout: workout)

                        var summary = WorkoutSummary(
                            date: workout.startDate,
                            type: workout.workoutActivityType.name,
                            duration: workout.duration / 60.0,
                            avgHeartRate: hrStats.avg,
                            minHeartRate: hrStats.min,
                            maxHeartRate: hrStats.max,
                            zone1Minutes: hrStats.z1,
                            zone2Minutes: hrStats.z2,
                            zone3Minutes: hrStats.z3,
                            zone4Minutes: hrStats.z4,
                            zone5Minutes: hrStats.z5,
                            effortScore: effort,
                            totalDistance: workout.totalDistance?.doubleValue(for: .meterUnit(with: .kilo)),
                            elevationGain: (workout.metadata?[HKMetadataKeyElevationAscended] as? HKQuantity)?.doubleValue(for: .meter()),
                            averageSpeed: nil,
                            averagePace: nil,
                            heartRateRecovery: hrr
                        )

                        if let dist = summary.totalDistance, summary.duration > 0 {
                            summary.averageSpeed = dist / (summary.duration / 60.0)
                            if dist > 0 { summary.averagePace = summary.duration / dist }
                        }
                        return summary
                    }
                }
                for await summary in group { workoutSummaries.append(summary) }
            }
        }

        return workoutSummaries.sorted(by: { $0.date < $1.date })
    }

    private func fetchWorkoutHeartRateData(workout: HKWorkout, thresholds: (z1: Double, z2: Double, z3: Double, z4: Double, z5: Double)) async -> (avg: Double?, min: Double?, max: Double?, z1: Double, z2: Double, z3: Double, z4: Double, z5: Double) {
        let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(sampleType: hrType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                guard let hrSamples = samples as? [HKQuantitySample], !hrSamples.isEmpty else {
                    continuation.resume(returning: (nil, nil, nil, 0, 0, 0, 0, 0))
                    return
                }

                let hrValues = hrSamples.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
                let avg = hrValues.reduce(0, +) / Double(hrValues.count)
                let min = hrValues.min()
                let max = hrValues.max()

                let secPerSample = workout.duration / Double(hrValues.count)
                var z1 = 0.0, z2 = 0.0, z3 = 0.0, z4 = 0.0, z5 = 0.0

                for hr in hrValues {
                    if hr >= thresholds.z5 { z5 += secPerSample / 60.0 }
                    else if hr >= thresholds.z4 { z4 += secPerSample / 60.0 }
                    else if hr >= thresholds.z3 { z3 += secPerSample / 60.0 }
                    else if hr >= thresholds.z2 { z2 += secPerSample / 60.0 }
                    else if hr >= thresholds.z1 { z1 += secPerSample / 60.0 }
                }
                continuation.resume(returning: (avg, min, max, z1, z2, z3, z4, z5))
            }
            self.healthStore.execute(query)
        }
    }

    private func fetchWorkoutHeartRateRecovery(workout: HKWorkout) async -> Double? {
        let hrrType = HKQuantityType.quantityType(forIdentifier: .heartRateRecoveryOneMinute)!
        let predicate = HKQuery.predicateForSamples(withStart: workout.endDate, end: workout.endDate.addingTimeInterval(900), options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(sampleType: hrrType, predicate: predicate, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]) { _, samples, _ in
                let val = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: HKUnit(from: "count/min"))
                continuation.resume(returning: val)
            }
            self.healthStore.execute(query)
        }
    }

    private func fetchWorkoutEffortScore(workout: HKWorkout) async -> Double? {
        if #available(iOS 18.0, *) {
            let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
            let effortType = HKQuantityType.quantityType(forIdentifier: .workoutEffortScore)!
            let estimatedType = HKQuantityType.quantityType(forIdentifier: .estimatedWorkoutEffortScore)!

            async let score = self.fetchLatestSample(type: effortType, predicate: predicate, unit: HKUnit(from: "appleEffortScore"))
            async let estimated = self.fetchLatestSample(type: estimatedType, predicate: predicate, unit: HKUnit(from: "appleEffortScore"))

            if let s = await score { return s }
            return await estimated
        }
        return nil
    }

    private func fetchLatestSample(type: HKQuantityType, predicate: NSPredicate, unit: HKUnit) async -> Double? {
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
                continuation.resume(returning: (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit))
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchLatestQuantity(for identifier: HKQuantityTypeIdentifier, unit: HKUnit) async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return nil }

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }
                _ = isCompleted.getAndSet(true)
                continuation.resume(returning: (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit))
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if !isCompleted.getAndSet(true) { _ = isCompleted.getAndSet(true); continuation.resume(returning: nil) }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchMindfulMinutes(months: [ExportMonth]) async -> [Date: Double] {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession),
              let firstMonth = months.first,
              let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }

                var stats: [Date: Double] = [:]
                if let mindfulSamples = samples as? [HKCategorySample] {
                    for sample in mindfulSamples {
                        let day = calendar.startOfDay(for: sample.startDate)
                        let duration = sample.endDate.timeIntervalSince(sample.startDate)
                        stats[day, default: 0] += duration / 60.0
                    }
                }
                continuation.resume(returning: stats)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) { continuation.resume(returning: [:]) }
            }
            self.healthStore.execute(query)
        }
    }

    @available(iOS 17.0, *)
    nonisolated private func fetchStateOfMind(months: [ExportMonth]) async -> [Date: Double] {
        let somType = HKObjectType.stateOfMindType()
        guard let firstMonth = months.first, let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let isCompleted = AtomicBool()
            let query = HKSampleQuery(sampleType: somType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                if isCompleted.getAndSet(true) { return }

                var dailyValences: [Date: [Double]] = [:]
                if let somSamples = samples as? [HKStateOfMind] {
                    for sample in somSamples {
                        let day = calendar.startOfDay(for: sample.startDate)
                        dailyValences[day, default: []].append(sample.valence)
                    }
                }
                continuation.resume(returning: dailyValences.mapValues { $0.reduce(0, +) / Double($0.count) })
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if !isCompleted.getAndSet(true) { continuation.resume(returning: [:]) }
            }
            self.healthStore.execute(query)
        }
    }

    nonisolated private func fetchCalculatedHeartRateDecelerationIndex(months: [ExportMonth]) async -> [Date: Double] {
        let heartbeatType = HKSeriesType.heartbeat()
        guard let firstMonth = months.first, let lastMonth = months.last else { return [:] }

        let calendar = Calendar.current
        let start = firstMonth.date
        let end = calendar.date(byAdding: .month, value: 1, to: lastMonth.date)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let samples: [HKHeartbeatSeriesSample] = await withCheckedContinuation { continuation in
            let query = HKSampleQuery(sampleType: heartbeatType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, result, _ in
                continuation.resume(returning: (result as? [HKHeartbeatSeriesSample]) ?? [])
            }
            healthStore.execute(query)
        }

        var dailyDCs: [Date: [Double]] = [:]

        for sample in samples {
            let sampleDC = await withCheckedContinuation { (continuation: CheckedContinuation<Double?, Never>) in
                var heartbeats: [(time: TimeInterval, precededByGap: Bool)] = []
                let query = HKHeartbeatSeriesQuery(heartbeatSeries: sample) { _, timeSinceSeriesStart, precededByGap, done, error in
                    if error != nil || done {
                        // Calculate sample DC
                        if heartbeats.count < 4 {
                            continuation.resume(returning: nil)
                            return
                        }

                        var rrIntervals: [(val: Double, valid: Bool)] = []
                        for i in 1..<heartbeats.count {
                            let interval = heartbeats[i].time - heartbeats[i-1].time
                            rrIntervals.append((val: interval, valid: !heartbeats[i].precededByGap))
                        }

                        var anchorDCs: [Double] = []
                        // Formula: DC = [RR[i] + RR[i+1] - RR[i-1] - RR[i-2]] / 4
                        // We need 4 consecutive RR intervals: RR[i-2], RR[i-1], RR[i], RR[i+1]
                        for i in 2..<(rrIntervals.count - 1) {
                            let rrm2 = rrIntervals[i-2]
                            let rrm1 = rrIntervals[i-1]
                            let rr0 = rrIntervals[i]
                            let rrp1 = rrIntervals[i+1]

                            // Anchor condition: RR[i] > RR[i-1]
                            if rr0.val > rrm1.val && rrm2.valid && rrm1.valid && rr0.valid && rrp1.valid {
                                let dcIndex = (rr0.val + rrp1.val - rrm1.val - rrm2.val) / 4.0
                                anchorDCs.append(dcIndex)
                            }
                        }

                        if anchorDCs.isEmpty {
                            continuation.resume(returning: nil)
                        } else {
                            let averageDC = anchorDCs.reduce(0, +) / Double(anchorDCs.count)
                            continuation.resume(returning: averageDC * 1000.0) // Convert to ms
                        }
                        return
                    }
                    heartbeats.append((time: timeSinceSeriesStart, precededByGap: precededByGap))
                }
                healthStore.execute(query)
            }

            if let dc = sampleDC {
                let day = calendar.startOfDay(for: sample.startDate)
                dailyDCs[day, default: []].append(dc)
            }
        }

        return dailyDCs.mapValues { $0.reduce(0, +) / Double($0.count) }
    }

    private func formatSymptomName(_ rawValue: String) -> String {
        // HKCategoryTypeIdentifierAbdominalCramps -> Abdominal Cramps
        let name = rawValue.replacingOccurrences(of: "HKCategoryTypeIdentifier", with: "")
        // Add spaces before capital letters
        var result = ""
        for char in name {
            if char.isUppercase && !result.isEmpty {
                result.append(" ")
            }
            result.append(char)
        }
        return result
    }

}

extension HKElectrocardiogram.Classification {
    nonisolated var name: String {
        switch self {
        case .notSet: return "notSet"
        case .sinusRhythm: return "sinusRhythm"
        case .atrialFibrillation: return "atrialFibrillation"
        case .inconclusiveLowHeartRate: return "inconclusiveLowHeartRate"
        case .inconclusiveHighHeartRate: return "inconclusiveHighHeartRate"
        case .inconclusivePoorReading: return "inconclusivePoorReading"
        case .inconclusiveOther: return "inconclusiveOther"
        case .unrecognized: return "unrecognized"
        @unknown default: return "unknown"
        }
    }
}

extension HKWorkoutActivityType {
    nonisolated var name: String {
        switch self {
        case .americanFootball: return "American Football"
        case .archery: return "Archery"
        case .australianFootball: return "Australian Football"
        case .badminton: return "Badminton"
        case .baseball: return "Baseball"
        case .basketball: return "Basketball"
        case .bowling: return "Bowling"
        case .boxing: return "Boxing"
        case .climbing: return "Climbing"
        case .crossTraining: return "Cross Training"
        case .curling: return "Curling"
        case .cycling: return "Cycling"
        case .dance: return "Dance"
        case .danceInspiredTraining: return "Dance Inspired Training"
        case .elliptical: return "Elliptical"
        case .equestrianSports: return "Equestrian Sports"
        case .fencing: return "Fencing"
        case .fishing: return "Fishing"
        case .functionalStrengthTraining: return "Functional Strength Training"
        case .golf: return "Golf"
        case .gymnastics: return "Gymnastics"
        case .handball: return "Handball"
        case .hiking: return "Hiking"
        case .hockey: return "Hockey"
        case .hunting: return "Hunting"
        case .lacrosse: return "Lacrosse"
        case .martialArts: return "Martial Arts"
        case .mindAndBody: return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports: return "Paddle Sports"
        case .play: return "Play"
        case .preparationAndRecovery: return "Preparation and Recovery"
        case .racquetball: return "Racquetball"
        case .rowing: return "Rowing"
        case .rugby: return "Rugby"
        case .running: return "Running"
        case .sailing: return "Sailing"
        case .skatingSports: return "Skating Sports"
        case .snowSports: return "Snow Sports"
        case .soccer: return "Soccer"
        case .softball: return "Softball"
        case .squash: return "Squash"
        case .stairClimbing: return "Stair Climbing"
        case .surfingSports: return "Surfing Sports"
        case .swimming: return "Swimming"
        case .tableTennis: return "Table Tennis"
        case .tennis: return "Tennis"
        case .trackAndField: return "Track and Field"
        case .traditionalStrengthTraining: return "Traditional Strength Training"
        case .volleyball: return "Volleyball"
        case .walking: return "Walking"
        case .waterFitness: return "Water Fitness"
        case .waterPolo: return "Water Polo"
        case .waterSports: return "Water Sports"
        case .wrestling: return "Wrestling"
        case .yoga: return "Yoga"
        case .barre: return "Barre"
        case .coreTraining: return "Core Training"
        case .crossCountrySkiing: return "Cross Country Skiing"
        case .downhillSkiing: return "Downhill Skiing"
        case .flexibility: return "Flexibility"
        case .highIntensityIntervalTraining: return "HIIT"
        case .jumpRope: return "Jump Rope"
        case .kickboxing: return "Kickboxing"
        case .pilates: return "Pilates"
        case .snowboarding: return "Snowboarding"
        case .stairs: return "Stairs"
        case .stepTraining: return "Step Training"
        case .wheelchairWalkPace: return "Wheelchair Walk Pace"
        case .wheelchairRunPace: return "Wheelchair Run Pace"
        case .taiChi: return "Tai Chi"
        case .mixedCardio: return "Mixed Cardio"
        case .handCycling: return "Hand Cycling"
        case .discSports: return "Disc Sports"
        case .fitnessGaming: return "Fitness Gaming"
        case .cardioDance: return "Cardio Dance"
        case .socialDance: return "Social Dance"
        case .pickleball: return "Pickleball"
        case .cooldown: return "Cooldown"
        case .swimBikeRun: return "Swim Bike Run"
        case .transition: return "Transition"
        case .underwaterDiving: return "Underwater Diving"
        case .other: return "Other"
        default: return "Workout"
    }
}
}

nonisolated class AtomicBool: @unchecked Sendable {
    private let lock = NSLock()
    private var value: Bool = false

    nonisolated init() {}

    nonisolated func getAndSet(_ newValue: Bool) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        let oldValue = value
        value = newValue
        return oldValue
    }
}
