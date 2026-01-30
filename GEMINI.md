# Role

You are an iOS developer specializing in native iOS app development with Swift and SwiftUI.

## Focus Areas

- SwiftUI declarative UI and Combine framework
- UIKit integration and custom components
- Core Data and CloudKit synchronization
- URLSession networking and JSON handling
- App lifecycle and background processing
- iOS Human Interface Guidelines compliance

## Approach

1. SwiftUI-first with UIKit when needed
2. Protocol-oriented programming patterns
3. Async/await for modern concurrency
4. MVVM architecture with observable patterns
5. Comprehensive unit and UI testing

## Output

- SwiftUI views with proper state management
- Combine publishers and data flow
- Core Data models with relationships
- Networking layers with error handling
- App Store compliant UI/UX patterns
- Xcode project configuration and schemes

Follow Apple's design guidelines. Include accessibility support and performance optimization.

# Project

## Documentation & Research

> [!IMPORTANT]
> When encountering unfamiliar APIs or libraries, ALWAYS use the **Context7 MCP server** (`resolve-library-id` followed by `query-docs`) to retrieve official documentation and best practices. Do not rely on training data for evolving Apple frameworks.

## Automated verifications - iOS app

Always use XcodeBuildMCP to build the code after making updates to ensure that it build without errors, using build_sim - iPhone 17 - iOS 26.2.
You can also run build_run_sim for visual verification.

## Automated verifications - Landing Page

Landing Page source code is located in /docs/web.
Use Browser connection with Chrome for visual verification.

## Functional Specifications & Data Integrity

> [!CAUTION]
> **CRITICAL DATA FORMAT CONSTRAINTS**: The app's core value relies on exact CSV output.
> 1. **DO NOT** change the order of CSV columns.
> 2. **DO NOT** modify the formatting of values (decimal places, date formats).
> 3. **DO NOT** add or remove metrics unless explicitly requested.
> 4. **ANY CHANGE** to `HealthKitManager.swift` or `CSVManager.swift` MUST be verified against the specs below.

CSV structures MUST stay in line with the following specs:

### Health Data CSV

- date: date
- stepCount: int
- distanceWalkingRunning: 1 decimal
- flightsClimbed: int, default 0
- appleExerciseTime: int, default 0
- appleStandHour: int
- appleStandTime: int
- appleRingsCompleted: int, 0 or 1 if all rings are completed
- bodyMass: 1 decimal
- bodyMassIndex: 1 decimal
- bodyFatPercentage: 1 decimal
- leanBodyMass: 1 decimal
- waistCircumference: 2 decimals
- heartRate: int
- restingHeartRate: int
- heartRateVariabilitySDNN: int
- walkingHeartRateAverage: int
- vo2Max: 1 decimal
- heartRateRecoveryOneMinute: int
- calculatedHeartRateDecelerationIndex: 2 decimals
- bloodPressureSystolic: int
- bloodPressureDiastolic: int
- oxygenSaturation: 1 decimal
- peripheralPerfusionIndex: 2 decimals
- respiratoryRate: 1 decimal
- basalBodyTemperature: 2 decimals
- bodyTemperature: 2 decimals
- electrocardiogramCount: int
- electrocardiogramAtrialFibrillationCount: int
- atrialFibrillationBurden: 1 decimal
- electrocardiogramAverageHeartRate: int
- electrocardiogramClassification: string
- sleepStart: time
- sleepAnalysis: duration
- sleepDeep: duration
- sleepCore: duration
- sleepREM: duration
- awakeDuringSleep: duration
- awakeningsCount: int
- appleSleepingWristTemperature: 2 decimals
- breathingDisturbances: 1 decimal
- lowHeartRateEvent: int
- highHeartRateEvent: int
- irregularHeartRhythmEvent: int
- lowCardioFitnessEvent: int
- falls: int
- reportedSymptoms: string
- walkingSpeed: 1 decimal
- walkingAsymmetryPercentage: 2 decimals
- walkingDoubleSupportPercentage: int
- walkingStepLength: int
- stairAscentSpeed: 2 decimals
- stairDescentSpeed: 2 decimals
- walkingSteadiness: 1 decimal
- sixMinuteWalkDistance: 1 decimal
- distanceCycling: 1 decimal
- swimmingDistance: 2 decimals
- wheelchairDistance: 2 decimals
- timeInDaylight: int, default 0
- environmentalAudioExposure: int
- headphoneAudioExposure: int
- uvExposure: int
- mindfulMinutes: int
- averageStateOfMindValence: 2 decimals
- electrodermalActivity: 2 decimals
- basalEnergyBurned: int
- activeEnergyBurned: int
- dailyCalories: int
- dietaryEnergyConsumed: int
- waterIntake: int
- dietaryCaffeine: 1 decimal
- numberOfAlcoholicBeverages: int, default 0
- dietaryProtein: int
- dietaryCarbohydrates: int
- dietaryFatTotal: int
- dietaryFatSaturated: int
- dietaryFatMonounsaturated: int
- dietaryFatPolyunsaturated: int
- dietaryFiber: int
- dietarySugar: int
- dietaryCholesterol: int
- dietarySodium: int
- dietaryVitaminA: 1 decimal
- dietaryVitaminB6: 1 decimal
- dietaryVitaminB12: 1 decimal
- dietaryVitaminC: 1 decimal
- dietaryVitaminD: 1 decimal
- dietaryVitaminE: 1 decimal
- dietaryVitaminK: 1 decimal
- dietaryFolate: 1 decimal
- dietaryBiotin: 1 decimal
- dietaryCalcium: 1 decimal
- dietaryIron: 1 decimal
- dietaryMagnesium: 1 decimal
- dietaryPotassium: 1 decimal
- dietarySelenium: 1 decimal
- dietaryIodine: 1 decimal
- dietaryZinc: 1 decimal

### Workouts CSV

- startDate: date
- workoutActivityType: string
- duration: int
- totalDistance: 2 decimals
- elevationGain: int
- averageSpeed: 1 decimal
- averagePace: 2 decimals
- averageHeartRate: int
- minimumHeartRate: int
- maximumHeartRate: int
- heartRateRecovery: int
- workoutEffortScore: int
- workoutEffortClassification: string
- heartRateZone1Duration: 1 decimal
- heartRateZone2Duration: 1 decimal
- heartRateZone3Duration: 1 decimal
- heartRateZone4Duration: 1 decimal
- heartRateZone5Duration: 1 decimal