//
//  SignupViewModel.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func signUp() async -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            try await AuthService.shared.register(username: username, email: email, password: password)
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Sign up failed."
            return false
        }
    }
}

