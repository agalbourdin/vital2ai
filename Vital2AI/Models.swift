import Foundation
import HealthKit

struct ExportMonth: Identifiable, Hashable, Sendable {
    var id: Date { date }
    let date: Date // First day of the month
    var name: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

extension ExportMonth: Equatable {
    nonisolated static func == (lhs: ExportMonth, rhs: ExportMonth) -> Bool {
        lhs.date == rhs.date
    }
}

struct DailySummary: Sendable {
    var date: Date

    var stepCount: Double?
    var distanceWalkingRunning: Double?
    var flightsClimbed: Double?
    var appleStandHour: Double?
    var activeEnergyBurned: Double?
    var appleExerciseTime: Double?
    var bodyMass: Double?
    var bodyMassIndex: Double?
    var heartRate: Double?
    var restingHeartRate: Double?
    var heartRateVariabilitySDNN: Double?
    var oxygenSaturation: Double?
    var walkingHeartRateAverage: Double?
    var sleepAnalysis: Double?
    var sleepDeep: Double?
    var sleepCore: Double?
    var sleepREM: Double?
    var sleepStart: Date?
    var awakeDuringSleep: Double?
    var awakeningsCount: Int?
    var distanceCycling: Double?
    var vo2Max: Double?
    var heartRateRecoveryOneMinute: Double?
    var bodyFatPercentage: Double?
    var leanBodyMass: Double?
    var respiratoryRate: Double?
    var dietaryEnergyConsumed: Double?
    var dailyCalories: Double?
    var timeInDaylight: Double?
    var numberOfAlcoholicBeverages: Double?
    var environmentalAudioExposure: Double?
    var headphoneAudioExposure: Double?
    var basalEnergyBurned: Double?
    var walkingSpeed: Double?
    var walkingAsymmetryPercentage: Double?
    var walkingDoubleSupportPercentage: Double?
    var walkingStepLength: Double?
    var stairAscentSpeed: Double?
    var stairDescentSpeed: Double?
    var dietaryProtein: Double?
    var dietaryCarbohydrates: Double?
    var dietaryFatTotal: Double?
    var dietaryFatSaturated: Double?
    var dietaryFatMonounsaturated: Double?
    var dietaryFatPolyunsaturated: Double?
    var dietaryFiber: Double?
    var dietarySugar: Double?
    var dietaryCholesterol: Double?
    var dietarySodium: Double?
    var dietaryVitaminA: Double?
    var dietaryVitaminB6: Double?
    var dietaryVitaminB12: Double?
    var dietaryVitaminC: Double?
    var dietaryVitaminD: Double?
    var dietaryVitaminE: Double?
    var dietaryVitaminK: Double?
    var dietaryCalcium: Double?
    var dietaryIron: Double?
    var dietaryMagnesium: Double?
    var dietaryPotassium: Double?
    var dietaryZinc: Double?
    var dietaryCaffeine: Double?
    var lowHeartRateEvent: Int?
    var highHeartRateEvent: Int?
    var irregularHeartRhythmEvent: Int?
    var lowCardioFitnessEvent: Int?
    var falls: Double?
    var electrocardiogramCount: Int?
    var electrocardiogramAtrialFibrillationCount: Int?
    var electrocardiogramAverageHeartRate: Double?
    var electrocardiogramClassification: String?
    var appleSleepingWristTemperature: Double?
    var breathingDisturbances: Double?
    var atrialFibrillationBurden: Int?
    var bloodPressureSystolic: Double?
    var bloodPressureDiastolic: Double?
    var waterIntake: Double?
    var swimmingDistance: Double?
    var wheelchairDistance: Double?
    var waistCircumference: Double?
    var peripheralPerfusionIndex: Double?
    var bloodGlucose: Double?
    var insulinDelivery: Double?
    var basalBodyTemperature: Double?
    var bodyTemperature: Double?
    var peakExpiratoryFlowRate: Double?
    var forcedVitalCapacity: Double?
    var forcedExpiratoryVolume: Double?
    var walkingSteadiness: Double?
    var sixMinuteWalkDistance: Double?
    var mindfulMinutes: Double?
    var averageStateOfMindValence: Double?
    var uvExposure: Double?
    var electrodermalActivity: Double?
    var dietaryFolate: Double?
    var dietaryBiotin: Double?
    var dietarySelenium: Double?
    var dietaryIodine: Double?
    var appleStandTime: Double?
    var calculatedHeartRateDecelerationIndex: Double?

    var standHoursGoal: Double?
    var activeEnergyBurnedGoal: Double?
    var exerciseTimeGoal: Double?
    var appleRingsCompleted: Int?
    var symptoms: String?

    nonisolated var hasActualData: Bool {
        hasActivityData || hasBodyData || hasVitalsData || hasNutritionData || hasMobilityData || hasOtherData
    }

    nonisolated private var hasActivityData: Bool {
        stepCount != nil || distanceWalkingRunning != nil || flightsClimbed != nil ||
        appleStandHour != nil || activeEnergyBurned != nil || appleExerciseTime != nil ||
        distanceCycling != nil || swimmingDistance != nil || wheelchairDistance != nil ||
        appleStandTime != nil || basalEnergyBurned != nil
    }

    nonisolated private var hasBodyData: Bool {
        bodyMass != nil || bodyMassIndex != nil || bodyFatPercentage != nil ||
        leanBodyMass != nil || waistCircumference != nil
    }

    nonisolated private var hasVitalsData: Bool {
        heartRate != nil || restingHeartRate != nil || heartRateVariabilitySDNN != nil ||
        oxygenSaturation != nil || walkingHeartRateAverage != nil || vo2Max != nil ||
        heartRateRecoveryOneMinute != nil || respiratoryRate != nil || bloodPressureSystolic != nil ||
        bloodPressureDiastolic != nil || appleSleepingWristTemperature != nil ||
        breathingDisturbances != nil || atrialFibrillationBurden != nil ||
        electrocardiogramCount != nil || bloodGlucose != nil || insulinDelivery != nil ||
        basalBodyTemperature != nil || bodyTemperature != nil || calculatedHeartRateDecelerationIndex != nil
    }

    nonisolated private var hasNutritionData: Bool {
        dietaryEnergyConsumed != nil || dietaryProtein != nil || dietaryCarbohydrates != nil ||
        dietaryFatTotal != nil || dietaryFatSaturated != nil || dietaryFatMonounsaturated != nil ||
        dietaryFatPolyunsaturated != nil || dietaryFiber != nil || dietarySugar != nil ||
        dietaryCholesterol != nil || dietarySodium != nil || waterIntake != nil ||
        dietaryCaffeine != nil || numberOfAlcoholicBeverages != nil || dietaryFolate != nil ||
        dietaryBiotin != nil || dietarySelenium != nil || dietaryIodine != nil ||
        dietaryVitaminA != nil || dietaryVitaminB6 != nil || dietaryVitaminB12 != nil ||
        dietaryVitaminC != nil || dietaryVitaminD != nil || dietaryVitaminE != nil ||
        dietaryVitaminK != nil || dietaryCalcium != nil || dietaryIron != nil ||
        dietaryMagnesium != nil || dietaryPotassium != nil || dietaryZinc != nil
    }

    nonisolated private var hasMobilityData: Bool {
        walkingSpeed != nil || walkingAsymmetryPercentage != nil ||
        walkingDoubleSupportPercentage != nil || walkingStepLength != nil ||
        stairAscentSpeed != nil || stairDescentSpeed != nil ||
        walkingSteadiness != nil || sixMinuteWalkDistance != nil
    }

    nonisolated private var hasOtherData: Bool {
        timeInDaylight != nil || environmentalAudioExposure != nil ||
        headphoneAudioExposure != nil || falls != nil ||
        peakExpiratoryFlowRate != nil || forcedVitalCapacity != nil ||
        forcedExpiratoryVolume != nil || mindfulMinutes != nil ||
        averageStateOfMindValence != nil || uvExposure != nil ||
        electrodermalActivity != nil || symptoms != nil
    }
}

struct WorkoutSummary: Sendable {
    var date: Date
    var type: String
    var duration: Double // in minutes
    var avgHeartRate: Double?
    var minHeartRate: Double?
    var maxHeartRate: Double?
    var zone1Minutes: Double
    var zone2Minutes: Double
    var zone3Minutes: Double
    var zone4Minutes: Double
    var zone5Minutes: Double
    var effortScore: Double?
    var totalDistance: Double? // in km
    var elevationGain: Double? // in meters
    var averageSpeed: Double? // in km/h
    var averagePace: Double? // in min/km
    var heartRateRecovery: Double?
}

struct MedicalID: Sendable {
    var age: Int?
    var biologicalSex: String?
    var bloodType: String?
    var fitzpatrickSkinType: String?
    var height: Double?
    var bodyMass: Double?
    var wheelchairUse: String?
}

