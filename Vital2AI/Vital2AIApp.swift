import SwiftUI

@main
struct Vital2AIApp: App {
    init() {
        CSVManager.cleanupAllTemporaryFiles()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .preferredColorScheme(.dark)
        }
    }
}
