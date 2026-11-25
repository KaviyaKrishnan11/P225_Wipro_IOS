
import Foundation
import LocalAuthentication

final class BiometricService {

    func authenticate(
        completion: @escaping (Bool, String?) -> Void
    ) {
        let context = LAContext()
        var error: NSError?

        // Require Face ID or Touch ID only.
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            completion(
                false,
                error?.localizedDescription ?? "Biometric authentication is unavailable."
            )
            return
        }

        context.localizedReason = "Unlock your investment portfolio"
        context.localizedFallbackTitle = ""

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Unlock your investment portfolio"
        ) { success, authenticationError in

            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    completion(
                        false,
                        authenticationError?.localizedDescription
                            ?? "Face ID authentication failed."
                    )
                }
            }
        }
    }
}
