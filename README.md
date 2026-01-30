# Vital2AI

[Vital2AI](https://agalbourdin.github.io/vital2ai/) is a powerful, privacy-first iOS application designed to help users export their Apple Health data into clean, AI-ready CSV files.

## Features

- **Comprehensive Data Export**: Export daily summaries for a wide range of 90+ HealthKit metrics (steps, heart rate, sleep, nutrition, and more).
- **Workout Details**: Dedicated export for workout history, including duration, distance, and heart rate zones.
- **Privacy First**: All data processing happens on-device. No data is ever sent to a server.
- **AI-Ready Format**: CSV files are formatted specifically to be easily ingested and analyzed by LLMs and data analysis tools.
- **Biometric Protection**: Secure your exported data with FaceID or TouchID.
- **Automatic Cleanup**: Exported files are temporarily stored and automatically deleted for maximum security.

## Privacy

Privacy is a core tenet of this project.
- **On-Device Processing**: All calculations and CSV generations are performed locally on your iPhone.
- **No Analytics**: We do not track usage or collect any personal information.
- **Secure Handling**: Exported files are stored in the app's temporary directory and are removed once they are no longer needed.

## Full Metrics List

### Health Data
stepCount | distanceWalkingRunning | flightsClimbed | appleExerciseTime | appleStandHour | appleStandTime | appleRingsCompleted | bodyMass | bodyMassIndex | bodyFatPercentage | leanBodyMass | waistCircumference | heartRate | restingHeartRate | heartRateVariabilitySDNN | walkingHeartRateAverage | vo2Max | heartRateRecoveryOneMinute | calculatedHeartRateDecelerationIndex | bloodPressureSystolic | bloodPressureDiastolic | oxygenSaturation | peripheralPerfusionIndex | respiratoryRate | basalBodyTemperature | bodyTemperature | electrocardiogramCount | electrocardiogramAtrialFibrillationCount | atrialFibrillationBurden | electrocardiogramAverageHeartRate | electrocardiogramClassification | sleepStart | sleepAnalysis | sleepDeep | sleepCore | sleepREM | awakeDuringSleep | awakeningsCount | appleSleepingWristTemperature | breathingDisturbances | lowHeartRateEvent | highHeartRateEvent | irregularHeartRhythmEvent | lowCardioFitnessEvent | falls | reportedSymptoms | walkingSpeed | walkingAsymmetryPercentage | walkingDoubleSupportPercentage | walkingStepLength | stairAscentSpeed | stairDescentSpeed | walkingSteadiness | sixMinuteWalkDistance | distanceCycling | swimmingDistance | wheelchairDistance | timeInDaylight | environmentalAudioExposure | headphoneAudioExposure | uvExposure | mindfulMinutes | averageStateOfMindValence | electrodermalActivity | basalEnergyBurned | activeEnergyBurned | dailyCalories | dietaryEnergyConsumed | waterIntake | dietaryCaffeine | numberOfAlcoholicBeverages | dietaryProtein | dietaryCarbohydrates | dietaryFatTotal | dietaryFatSaturated | dietaryFatMonounsaturated | dietaryFatPolyunsaturated | dietaryFiber | dietarySugar | dietaryCholesterol | dietarySodium | dietaryVitaminA | dietaryVitaminB6 | dietaryVitaminB12 | dietaryVitaminC | dietaryVitaminD | dietaryVitaminE | dietaryVitaminK | dietaryFolate | dietaryBiotin | dietaryCalcium | dietaryIron | dietaryMagnesium | dietaryPotassium | dietarySelenium | dietaryIodine | dietaryZinc

### Workouts
startDate | workoutActivityType | duration | totalDistance | elevationGain | averageSpeed | averagePace | averageHeartRate | minimumHeartRate | maximumHeartRate | heartRateRecovery | workoutEffortScore | workoutEffortClassification | heartRateZone1Duration | heartRateZone2Duration | heartRateZone3Duration | heartRateZone4Duration | heartRateZone5Duration

### Note on Heart Rate Deceleration Index (DC)

> [!CAUTION]
> **EXPERIMENTAL METRIC**: The `calculatedHeartRateDecelerationIndex` is currently the only metric in this export that is calculated on-device by the app itself rather than being a direct value from Apple Health. While the calculation follows the established PRSA method, it is **not guaranteed to be correct** and has not been clinically validated. It should be used for informational and research purposes only.

Vital2AI calculates the Deceleration Capacity (DC) of the heart, a recognized prognostic marker of autonomic nervous system health. This metric is derived from heartbeat-to-beat interval (RR) data captured via `HKHeartbeatSeriesSample`.

The calculation follows the Phase-Rectified Signal Averaging (PRSA) method:

1. **Anchor Point Selection**: We identify points `i` where the current heartbeat interval is longer than the previous one ($RR_i > RR_{i-1}$), signaling a deceleration.
2. **Formula**: For each valid anchor point, the contribution is calculated as:
   $$DC_i = \frac{RR_i + RR_{i+1} - RR_{i-1} - RR_{i-2}}{4}$$
3. **Gap Handling**: Any data point preceded by a gap (as tagged by HealthKit) is excluded to ensure temporal continuity.
4. **Final Index**: The daily value is the average of all $DC_i$ calculated throughout the day, expressed in milliseconds (ms).

## AI Experiment

This application is an experiment in AI-assisted development, created using:
- **Logo**: Nano Banana
- **UI Design**: Google Stitch
- **Code**: Antigravity with Gemini 3
- **Content & Copy**: Gemini 3
- **AI Rules**: Gemini CLI Templates

## Medical Disclaimer

This app is for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.

## License

Distributed under the MIT License. See `LICENSE` for more information.

Created by [Alexis Galbourdin](https://www.alexisg.net/).