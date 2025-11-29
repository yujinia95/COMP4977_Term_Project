//
//  LoginViewModel.swift
//  AuroraAR
//
//  Created by Amal Allaham on 2025-11-19.
//
import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var usernameOrEmail = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    /// Attempts login and returns the AuthResponse (token + user) on success.
    func login() async -> AuthResponse? {
        guard !usernameOrEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email/username and password."
            return nil
        }

        isLoading = true
        errorMessage = nil

        do {
            // Normalize inputs: trim whitespace and use lowercase for username/email
            let identifier = usernameOrEmail.trimmingCharacters(in: .whitespacesAndNewlines)
            let normalizedIdentifier = identifier.lowercased()
            let pw = password.trimmingCharacters(in: .whitespacesAndNewlines)

            // 🔐 Call API and get token + user
            let auth = try await AuthService.shared.login(
                usernameOrEmail: normalizedIdentifier,
                password: pw
            )

            isLoading = false
            return auth
        } catch {
            isLoading = false
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
                ?? "Login failed."
            print("❌ [LoginViewModel] login error:", error)
            return nil
        }
    }
}
