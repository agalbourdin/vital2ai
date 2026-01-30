import Foundation

class CSVManager {
    nonisolated private static func format(_ value: Double?) -> String {
        return value.map { String($0) } ?? ""
    }

    nonisolated private static func formatInt(_ value: Double?) -> String {
        return value.map { String(Int($0.rounded())) } ?? ""
    }

    nonisolated private static func formatInt(_ value: Int?) -> String {
        return value.map { String($0) } ?? ""
    }

    nonisolated private static func formatOneDecimal(_ value: Double?) -> String {
        return value.map { String(format: "%.1f", $0) } ?? ""
    }

    nonisolated private static func formatTwoDecimals(_ value: Double?) -> String {
        return value.map { String(format: "%.2f", $0) } ?? ""
    }

    nonisolated private static func formatDuration(_ hrs: Double?) -> String {
        return hrs.map { String(format: "%.2f", $0) } ?? ""
    }

    nonisolated private static func formatEffortClassification(_ score: Double?) -> String {
        guard let score = score else { return "" }
        let rounded = Int(score.rounded())
        switch rounded {
        case 1...2: return "Easy"
        case 3...4: return "Moderate"
        case 5...6: return "Hard"
        case 7...8: return "Very Hard"
        case 9...10: return "All Out"
        default: return ""
        }
    }

    nonisolated static func generateCSV(from summaries: [DailySummary]) -> URL? {
        let baseDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()

        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        let headers = [
            "date",
            // Basic Activity & Rings
            "stepCount", "distanceWalkingRunning", "flightsClimbed", "appleExerciseTime", "appleStandHour", "appleStandTime", "appleRingsCompleted",
            // Body Metrics
            "bodyMass", "bodyMassIndex", "bodyFatPercentage", "leanBodyMass", "waistCircumference",
            // Heart Health & Vitals
            "heartRate", "restingHeartRate", "heartRateVariabilitySDNN", "walkingHeartRateAverage", "vo2Max", "heartRateRecoveryOneMinute", "calculatedHeartRateDecelerationIndex", "bloodPressureSystolic", "bloodPressureDiastolic", "oxygenSaturation", "peripheralPerfusionIndex", "respiratoryRate", "basalBodyTemperature", "bodyTemperature",
            // ECG & AFib
            "electrocardiogramCount", "electrocardiogramAtrialFibrillationCount", "atrialFibrillationBurden", "electrocardiogramAverageHeartRate", "electrocardiogramClassification",
            // Sleep
            "sleepStart", "sleepAnalysis", "sleepDeep", "sleepCore", "sleepREM", "awakeDuringSleep", "awakeningsCount", "appleSleepingWristTemperature", "breathingDisturbances",
            // Events & Symptoms
            "lowHeartRateEvent", "highHeartRateEvent", "irregularHeartRhythmEvent", "lowCardioFitnessEvent", "falls", "reportedSymptoms",
            // Mobility & Performance
            "walkingSpeed", "walkingAsymmetryPercentage", "walkingDoubleSupportPercentage", "walkingStepLength", "stairAscentSpeed", "stairDescentSpeed", "walkingSteadiness", "sixMinuteWalkDistance", "distanceCycling", "swimmingDistance", "wheelchairDistance",
            // Environmental & Lifestyle
            "timeInDaylight", "environmentalAudioExposure", "headphoneAudioExposure", "uvExposure", "mindfulMinutes", "averageStateOfMindValence", "electrodermalActivity", "basalEnergyBurned", "activeEnergyBurned", "dailyCalories",
            // Nutrition & Hydration
            "dietaryEnergyConsumed", "waterIntake", "dietaryCaffeine", "numberOfAlcoholicBeverages", "dietaryProtein", "dietaryCarbohydrates", "dietaryFatTotal", "dietaryFatSaturated", "dietaryFatMonounsaturated", "dietaryFatPolyunsaturated", "dietaryFiber", "dietarySugar", "dietaryCholesterol", "dietarySodium", "dietaryVitaminA", "dietaryVitaminB6", "dietaryVitaminB12", "dietaryVitaminC", "dietaryVitaminD", "dietaryVitaminE", "dietaryVitaminK", "dietaryFolate", "dietaryBiotin", "dietaryCalcium", "dietaryIron", "dietaryMagnesium", "dietaryPotassium", "dietarySelenium", "dietaryIodine", "dietaryZinc"
        ]

        var csvLines: [String] = [headers.joined(separator: ",")]

        for summary in summaries {
            var row: [String] = []

            row.append(baseDateFormatter.string(from: summary.date))

            // Basic Activity & Rings
            row.append(formatInt(summary.stepCount))
            row.append(formatOneDecimal(summary.distanceWalkingRunning))
            row.append(formatInt(summary.flightsClimbed ?? 0))
            row.append(formatInt(summary.appleExerciseTime ?? 0))
            row.append(formatInt(summary.appleStandHour))
            row.append(formatInt(summary.appleStandTime))
            row.append(formatInt(summary.appleRingsCompleted))

            // Body Metrics
            row.append(formatOneDecimal(summary.bodyMass))
            row.append(formatOneDecimal(summary.bodyMassIndex))
            row.append(summary.bodyFatPercentage.map { String(format: "%.1f", $0 * 100) } ?? "")
            row.append(formatOneDecimal(summary.leanBodyMass))
            row.append(formatTwoDecimals(summary.waistCircumference))

            // Heart Health & Vitals
            row.append(formatInt(summary.heartRate))
            row.append(formatInt(summary.restingHeartRate))
            row.append(formatInt(summary.heartRateVariabilitySDNN))
            row.append(formatInt(summary.walkingHeartRateAverage))
            row.append(formatOneDecimal(summary.vo2Max))
            row.append(formatInt(summary.heartRateRecoveryOneMinute))
            row.append(formatTwoDecimals(summary.calculatedHeartRateDecelerationIndex))
            row.append(formatInt(summary.bloodPressureSystolic))
            row.append(formatInt(summary.bloodPressureDiastolic))
            row.append(summary.oxygenSaturation.map { String(format: "%.1f", $0 * 100) } ?? "")
            row.append(formatTwoDecimals(summary.peripheralPerfusionIndex))
            row.append(formatOneDecimal(summary.respiratoryRate))
            row.append(formatTwoDecimals(summary.basalBodyTemperature))
            row.append(formatTwoDecimals(summary.bodyTemperature))

            // ECG & AFib
            row.append(formatInt(summary.electrocardiogramCount))
            row.append(formatInt(summary.electrocardiogramAtrialFibrillationCount))
            row.append(formatInt(summary.atrialFibrillationBurden))
            row.append(formatInt(summary.electrocardiogramAverageHeartRate))
            row.append(summary.electrocardiogramClassification ?? "")

            // Sleep
            row.append(timeFormatter.string(from: summary.sleepStart ?? .distantPast))
            if summary.sleepStart == nil { row[row.count-1] = "" }
            row.append(formatDuration(summary.sleepAnalysis))
            row.append(formatDuration(summary.sleepDeep))
            row.append(formatDuration(summary.sleepCore))
            row.append(formatDuration(summary.sleepREM))
            row.append(formatDuration(summary.awakeDuringSleep))
            row.append(formatInt(summary.awakeningsCount))
            row.append(formatTwoDecimals(summary.appleSleepingWristTemperature))
            row.append(formatOneDecimal(summary.breathingDisturbances))

            // Events & Symptoms
            row.append(formatInt(summary.lowHeartRateEvent))
            row.append(formatInt(summary.highHeartRateEvent))
            row.append(formatInt(summary.irregularHeartRhythmEvent))
            row.append(formatInt(summary.lowCardioFitnessEvent))
            row.append(formatInt(summary.falls))
            row.append(summary.symptoms ?? "")

            // Mobility & Performance
            row.append(formatOneDecimal(summary.walkingSpeed))
            row.append(formatTwoDecimals(summary.walkingAsymmetryPercentage))
            row.append(formatInt(summary.walkingDoubleSupportPercentage))
            row.append(formatInt(summary.walkingStepLength))
            row.append(formatTwoDecimals(summary.stairAscentSpeed))
            row.append(formatTwoDecimals(summary.stairDescentSpeed))
            row.append(formatOneDecimal(summary.walkingSteadiness))
            row.append(formatOneDecimal(summary.sixMinuteWalkDistance))
            row.append(formatOneDecimal(summary.distanceCycling))
            row.append(formatTwoDecimals(summary.swimmingDistance))
            row.append(formatTwoDecimals(summary.wheelchairDistance))

            // Environmental & Lifestyle
            row.append(formatInt(summary.timeInDaylight ?? 0))
            row.append(formatInt(summary.environmentalAudioExposure))
            row.append(formatInt(summary.headphoneAudioExposure))
            row.append(formatInt(summary.uvExposure))
            row.append(formatInt(summary.mindfulMinutes))
            row.append(formatTwoDecimals(summary.averageStateOfMindValence))
            row.append(formatTwoDecimals(summary.electrodermalActivity))
            row.append(formatInt(summary.basalEnergyBurned))
            row.append(formatInt(summary.activeEnergyBurned))
            row.append(formatInt(summary.dailyCalories))

            // Nutrition & Hydration
            row.append(formatInt(summary.dietaryEnergyConsumed))
            row.append(formatInt(summary.waterIntake))
            row.append(format(summary.dietaryCaffeine))
            row.append(formatInt(summary.numberOfAlcoholicBeverages ?? 0))
            row.append(formatInt(summary.dietaryProtein))
            row.append(formatInt(summary.dietaryCarbohydrates))
            row.append(formatInt(summary.dietaryFatTotal))
            row.append(formatInt(summary.dietaryFatSaturated))
            row.append(formatInt(summary.dietaryFatMonounsaturated))
            row.append(formatInt(summary.dietaryFatPolyunsaturated))
            row.append(formatInt(summary.dietaryFiber))
            row.append(formatInt(summary.dietarySugar))
            row.append(formatInt(summary.dietaryCholesterol))
            row.append(formatInt(summary.dietarySodium))
            row.append(formatOneDecimal(summary.dietaryVitaminA))
            row.append(formatOneDecimal(summary.dietaryVitaminB6))
            row.append(formatOneDecimal(summary.dietaryVitaminB12))
            row.append(formatOneDecimal(summary.dietaryVitaminC))
            row.append(formatOneDecimal(summary.dietaryVitaminD))
            row.append(formatOneDecimal(summary.dietaryVitaminE))
            row.append(formatOneDecimal(summary.dietaryVitaminK))
            row.append(formatOneDecimal(summary.dietaryFolate))
            row.append(formatOneDecimal(summary.dietaryBiotin))
            row.append(formatOneDecimal(summary.dietaryCalcium))
            row.append(formatOneDecimal(summary.dietaryIron))
            row.append(formatOneDecimal(summary.dietaryMagnesium))
            row.append(formatOneDecimal(summary.dietaryPotassium))
            row.append(formatOneDecimal(summary.dietarySelenium))
            row.append(formatOneDecimal(summary.dietaryIodine))
            row.append(formatOneDecimal(summary.dietaryZinc))

            csvLines.append(row.joined(separator: ","))
        }

        let csvString = csvLines.joined(separator: "\n")

        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory

        let fileName = "HealthData.csv"
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error writing CSV: \(error)")
            return nil
        }
    }

    nonisolated static func generateWorkoutsCSV(from workouts: [WorkoutSummary]) -> URL? {
        let dateTimeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter
        }()

        let headers = [
            "startDate", "workoutActivityType", "duration",
            "totalDistance", "elevationGain", "averageSpeed", "averagePace",
            "averageHeartRate", "minimumHeartRate", "maximumHeartRate", "heartRateRecovery",
            "workoutEffortScore", "workoutEffortClassification",
            "heartRateZone1Duration", "heartRateZone2Duration", "heartRateZone3Duration", "heartRateZone4Duration", "heartRateZone5Duration"
        ]

        var csvLines: [String] = [headers.joined(separator: ",")]

        for workout in workouts {
            var row: [String] = []

            row.append(dateTimeFormatter.string(from: workout.date))
            row.append(workout.type)
            row.append(formatInt(workout.duration))
            row.append(formatTwoDecimals(workout.totalDistance))
            row.append(formatInt(workout.elevationGain))
            row.append(formatOneDecimal(workout.averageSpeed))
            row.append(formatTwoDecimals(workout.averagePace))
            row.append(formatInt(workout.avgHeartRate))
            row.append(formatInt(workout.minHeartRate))
            row.append(formatInt(workout.maxHeartRate))
            row.append(formatInt(workout.heartRateRecovery))
            row.append(formatInt(workout.effortScore))
            row.append(formatEffortClassification(workout.effortScore))
            row.append(formatOneDecimal(workout.zone1Minutes))
            row.append(formatOneDecimal(workout.zone2Minutes))
            row.append(formatOneDecimal(workout.zone3Minutes))
            row.append(formatOneDecimal(workout.zone4Minutes))
            row.append(formatOneDecimal(workout.zone5Minutes))

            csvLines.append(row.joined(separator: ","))
        }

        let csvString = csvLines.joined(separator: "\n")

        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory

        let fileName = "Workouts.csv"
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error writing Workouts CSV: \(error)")
            return nil
        }
    }

    nonisolated static func generateMetricsMarkdown(medicalID: MedicalID? = nil) -> URL? {
        var profileSection = ""
        if let mid = medicalID {
            profileSection = """
            ## User Profile (Medical ID)

            | Characteristic | Value |
            | :--- | :--- |
            | **Age** | \(mid.age.map { String($0) } ?? "Not set") |
            | **Biological Sex** | \(mid.biologicalSex ?? "Not set") |
            | **Blood Type** | \(mid.bloodType ?? "Not set") |
            | **Phototype** | \(mid.fitzpatrickSkinType ?? "Not set") |
            | **Height** | \(mid.height.map { String(format: "%.1f cm", $0) } ?? "Not set") |
            | **Wheelchair Use** | \(mid.wheelchairUse ?? "Not set") |

            ---

            """
        }

        let markdownContent = """
\(profileSection)
# Metrics descriptions

## Health metrics

This document describes the health metrics included in the Health Data CSV files.

| Metric | Description | Unit |
| :--- | :--- | :--- |
| **date** | The date of the data record. | YYYY-MM-DD |
| --- | **Basic Activity & Rings** | --- |
| **stepCount** | Number of steps taken. | count |
| **distanceWalkingRunning** | Distance traveled by walking or running. | km |
| **flightsClimbed** | Number of flights of stairs climbed. | count |
| **appleExerciseTime** | Time spent in active exercise. | min |
| **appleStandHour** | Number of hours in which the user stood for at least 1 minute. | count |
| **appleStandTime** | Time spent standing. | min |
| **appleRingsCompleted** | Number of activity rings completed. | count |
| --- | **Body Metrics** | --- |
| **bodyMass** | Weight of the user. | kg |
| **bodyMassIndex** | Body Mass Index. | index |
| **bodyFatPercentage** | Percentage of fat in the body. | % |
| **leanBodyMass** | Weight of the body excluding fat. | kg |
| **waistCircumference** | Circumference of the waist. | cm |
| --- | **Heart Health & Vitals** | --- |
| **heartRate** | Heart rate at a given time or average for the day. | count/min |
| **restingHeartRate** | Heart rate while at rest. | count/min |
| **heartRateVariabilitySDNN** | Heart rate variability (SDNN). | ms |
| **walkingHeartRateAverage** | Average heart rate during walking. | count/min |
| **vo2Max** | Maximum rate of oxygen consumption. | ml/kg·min |
| **heartRateRecoveryOneMinute** | Heart rate recovery after one minute of exercise. | count/min |
| **calculatedHeartRateDecelerationIndex** | Heart rate deceleration index (DC) calculated from heartbeat series. | ms |
| **bloodPressureSystolic** | Systolic blood pressure. | mmHg |
| **bloodPressureDiastolic** | Diastolic blood pressure. | mmHg |
| **oxygenSaturation** | Blood oxygen saturation level. | % |
| **peripheralPerfusionIndex** | Percentage of peripheral perfusion. | % |
| **respiratoryRate** | Number of breaths per minute. | count/min |
| **basalBodyTemperature** | Basal body temperature. | °C |
| **bodyTemperature** | Body temperature. | °C |
| --- | **ECG & AFib** | --- |
| **electrocardiogramCount** | Number of ECG records. | count |
| **electrocardiogramAtrialFibrillationCount** | Number of ECG records with Atrial Fibrillation classification. | count |
| **atrialFibrillationBurden** | Percentage of time the heart shows signs of AFib (weekly average). | % |
| **electrocardiogramAverageHeartRate** | Average heart rate from ECG records. | count/min |
| **electrocardiogramClassification** | Classification of ECG records (e.g., Sinus Rhythm). | string |
| --- | **Sleep** | --- |
| **sleepStart** | Time at which the sleep session started. | HH:mm |
| **sleepAnalysis** | Duration of sleep. | hrs |
| **sleepDeep** | Duration of deep sleep. | hrs |
| **sleepCore** | Duration of core sleep. | hrs |
| **sleepREM** | Duration of REM sleep. | hrs |
| **awakeDuringSleep** | Time awake during sleep. | hrs |
| **awakeningsCount** | Number of awakenings. | count |
| **appleSleepingWristTemperature** | Wrist temperature measured during sleep. | °C |
| **breathingDisturbances** | Occurrences of breathing disturbances during sleep. | events/hr |
| --- | **Events & Symptoms** | --- |
| **lowHeartRateEvent** | Occurrence of low heart rate events. | count |
| **highHeartRateEvent** | Occurrence of high heart rate events. | count |
| **irregularHeartRhythmEvent** | Occurrence of irregular heart rhythm events. | count |
| **lowCardioFitnessEvent** | Occurrence of low cardio fitness events. | count |
| **falls** | Number of hard falls detected by Apple Watch. | count |
| **reportedSymptoms** | List of symptoms reported by the user on that day. | string |
| --- | **Mobility & Performance** | --- |
| **walkingSpeed** | Speed during walking. | km/hr |
| **walkingAsymmetryPercentage** | Percentage of asymmetry in walking gait. | % |
| **walkingDoubleSupportPercentage** | Percentage of time both feet are on the ground during walking. | % |
| **walkingStepLength** | Average length of a walking step. | cm |
| **stairAscentSpeed** | Speed while climbing stairs. | m/s |
| **stairDescentSpeed** | Speed while descending stairs. | m/s |
| **walkingSteadiness** | Percentage of walking steadiness. | % |
| **sixMinuteWalkDistance** | Distance walked in six minutes. | m |
| **distanceCycling** | Distance traveled by cycling. | km |
| **swimmingDistance** | Distance traveled while swimming. | m |
| **wheelchairDistance** | Distance traveled while using a wheelchair. | m |
| --- | **Environmental & Lifestyle** | --- |
| **timeInDaylight** | Time spent in daylight. | min |
| **environmentalAudioExposure** | Level of exposure to environmental sound. | dBASPL |
| **headphoneAudioExposure** | Level of exposure to audio from headphones. | dBASPL |
| **uvExposure** | Level of UV exposure. | count |
| **mindfulMinutes** | Time spent in mindful sessions. | min |
| **averageStateOfMindValence** | Average valence (pleasantness) of state of mind logs. | scale (-1 to 1) |
| **electrodermalActivity** | Skin conductance (EDA). | S |
| **basalEnergyBurned** | Energy burned by the body at rest. | kcal |
| **activeEnergyBurned** | Energy burned through physical activity. | kcal |
| **dailyCalories** | Total calories consumed in a day (Active + Basal). | kcal |
| --- | **Nutrition & Hydration** | --- |
| **dietaryEnergyConsumed** | Total energy intake from food. | kcal |
| **waterIntake** | Amount of water consumed. | ml |
| **dietaryCaffeine** | Caffeine intake. | mg |
| **numberOfAlcoholicBeverages** | Number of alcoholic drinks consumed. | count |
| **dietaryProtein** | Protein intake. | g |
| **dietaryCarbohydrates** | Carbohydrate intake. | g |
| **dietaryFatTotal** | Total fat intake. | g |
| **dietaryFatSaturated** | Saturated fat intake. | g |
| **dietaryFatMonounsaturated** | Monounsaturated fat intake. | g |
| **dietaryFatPolyunsaturated** | Polyunsaturated fat intake. | g |
| **dietaryFiber** | Fiber intake. | g |
| **dietarySugar** | Sugar intake. | g |
| **dietaryCholesterol** | Cholesterol intake. | mg |
| **dietarySodium** | Sodium intake. | mg |
| **dietaryVitaminA** | Vitamin A intake. | mcg |
| **dietaryVitaminB6** | Vitamin B6 intake. | mg |
| **dietaryVitaminB12** | Vitamin B12 intake. | mcg |
| **dietaryVitaminC** | Vitamin C intake. | mg |
| **dietaryVitaminD** | Vitamin D intake. | mcg |
| **dietaryVitaminE** | Vitamin E intake. | mg |
| **dietaryVitaminK** | Vitamin K intake. | mcg |
| **dietaryFolate** | Folate intake. | mcg |
| **dietaryBiotin** | Biotin intake. | mcg |
| **dietaryCalcium** | Calcium intake. | mg |
| **dietaryIron** | Iron intake. | mg |
| **dietaryMagnesium** | Magnesium intake. | mg |
| **dietaryPotassium** | Potassium intake. | mg |
| **dietarySelenium** | Selenium intake. | mcg |
| **dietaryIodine** | Iodine intake. | mcg |
| **dietaryZinc** | Zinc intake. | mg |

---

## Workouts metrics

This section describes the metrics included in the Workouts CSV files.

| Metric | Description | Unit |
| :--- | :--- | :--- |
| **startDate** | The start date and time of the workout. | YYYY-MM-DD HH:mm |
| **workoutActivityType** | The type of physical activity (e.g., Running, Cycling, Yoga). | string |
| **duration** | The total duration of the workout. | min |
| **totalDistance** | Total distance covered during the workout. | km |
| **elevationGain** | Total elevation gained during the workout. | m |
| **averageSpeed** | Average speed during the workout. | km/h |
| **averagePace** | Average pace during the workout. | min/km |
| **averageHeartRate** | The average heart rate recorded during the workout. | count/min |
| **minimumHeartRate** | The minimum heart rate recorded during the workout. | count/min |
| **maximumHeartRate** | The maximum heart rate recorded during the workout. | count/min |
| **heartRateRecovery** | The reduction in heart rate one minute after the workout ends. | bpm |
| **workoutEffortScore** | A numerical score representing the intensity of the workout. | scale (1-10) |
| **workoutEffortClassification** | A human-readable classification based on the effort score (e.g., Moderate). | string |
| **heartRateZone1Duration** | Time spent in Heart Rate Zone 1 (Very Light). | min |
| **heartRateZone2Duration** | Time spent in Heart Rate Zone 2 (Light). | min |
| **heartRateZone3Duration** | Time spent in Heart Rate Zone 3 (Moderate). | min |
| **heartRateZone4Duration** | Time spent in Heart Rate Zone 4 (Hard). | min |
| **heartRateZone5Duration** | Time spent in Heart Rate Zone 5 (Maximum). | min |
"""

        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("Guide.md")

        do {
            try markdownContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error writing Markdown: \\\\(error)")
            return nil
        }
    }


    nonisolated static func cleanupTemporaryFiles(urls: [URL]) {
        let fileManager = FileManager.default
        for url in urls {
            do {
                if fileManager.fileExists(atPath: url.path) {
                    try fileManager.removeItem(at: url)
                }
            } catch {
                print("Error cleaning up temporary file: \(error)")
            }
        }
    }
    nonisolated static func cleanupAllTemporaryFiles() {
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        do {
            let files = try fileManager.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: nil)
            let filesToDelete = files.filter {
                $0.pathExtension == "csv" || $0.lastPathComponent == "Guide.md"
            }
            cleanupTemporaryFiles(urls: filesToDelete)
        } catch {
            print("Error listing temporary directory: \(error)")
        }
    }
}
