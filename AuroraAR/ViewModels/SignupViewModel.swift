import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func signUp() async -> AuthResponse? {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return nil
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return nil
        }

        isLoading = true
        errorMessage = nil

        do {
            let auth = try await AuthService.shared.register(
                username: username,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )
            isLoading = false
            return auth
        } catch {
            isLoading = false
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
                ?? "Sign up failed."
            print("❌ [SignupViewModel] signUp error:", error)
            return nil
        }
    }
}
