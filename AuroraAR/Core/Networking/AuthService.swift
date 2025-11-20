//
//  AuthService.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
//  This file provides a simple authentication for sending login
//  and signup requests to the backend
//  It validates the HTTP response. A 200 response is treated as a successful login/signup.
//

import Foundation

// For possible authentication related errors
enum AuthError: Error, LocalizedError {
    
    // Didn't get a valid HTTP response
    case invalidResponse
    // HTTP error status code with a message
    case server(String)
    
    // descriptions for UI display.
    var errorDescription: String? {
        switch self {
            
        case .invalidResponse:
            return "Invalid response. Please try again!"
            
        case .server(let message):
            return message
        }
    }
}


// Handles all login and registration requests
final class AuthService {
    
    // Singleton instance
    static let shared = AuthService()
    private init() {}


    // Send login request to the backend
    func login(usernameOrEmail: String, password: String) async throws {
        let body = LoginRequest(usernameOrEmail: usernameOrEmail, password: password)
        try await send(body, to: Config.loginURL)
    }

    // Send registration request to the backend
    func register(username: String, email: String, password: String) async throws {
        let body = RegisterRequest(username: username, email: email, password: password)
        try await send(body, to: Config.registerURL)
    }

    // Handles all POST requests. Encodes request body, sets headers, and ensures HTTP status is 2xx.
    private func send<T: Encodable>(_ body: T, to url: URL) async throws {
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        // Make HTTP call
        let (_, response) = try await URLSession.shared.data(for: request)

        // Ensure receive a proper HTTP response
        guard let http = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        // Check if backend returned a success status code
        guard (200..<300).contains(http.statusCode) else {
            let message = HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
            throw AuthError.server(message)
        }
    }
}

