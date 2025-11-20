//
//  LoginViewModel.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var usernameOrEmail = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func login() async -> Bool {
        guard !usernameOrEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {
            try await AuthService.shared.login(usernameOrEmail: usernameOrEmail, password: password)
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Login failed."
            return false
        }
    }
}

