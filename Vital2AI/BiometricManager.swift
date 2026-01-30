import LocalAuthentication
import Combine

class BiometricManager: ObservableObject {
    enum BiometricError: Error, LocalizedError {
        case notAvailable
        case failed
        case canceled
        case unknown

        var errorDescription: String? {
            switch self {
            case .notAvailable:
                return String(localized: "error_biometric_not_available")
            case .failed:
                return String(localized: "error_auth_failed")
            case .canceled:
                return String(localized: "error_auth_canceled")
            case .unknown:
                return String(localized: "error_unknown")
            }
        }
    }

    func authenticate(completion: @escaping (Result<Void, BiometricError>) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if authentication is available (Biometrics or Passcode)
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = String(localized: "biometric_reason")

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(.success(()))
                    } else {
                        if let laError = authenticationError as? LAError {
                            switch laError.code {
                            case .userCancel, .appCancel, .systemCancel:
                                completion(.failure(.canceled))
                            default:
                                completion(.failure(.failed))
                            }
                        } else {
                            completion(.failure(.unknown))
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(.notAvailable))
            }
        }
    }
}
