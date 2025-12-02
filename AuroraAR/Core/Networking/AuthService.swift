import Foundation

enum AuthError: Error, LocalizedError {
    case invalidResponse
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response. Please try again!"
        case .server(let message):
            return message
        }
    }
}


private struct ServerErrorResponse: Decodable {
    let message: String?
}

final class AuthService {
    static let shared = AuthService()
    private init() {}

    // MARK: - Login

    func login(usernameOrEmail: String, password: String) async throws -> AuthResponse {
        let body = LoginRequest(usernameOrEmail: usernameOrEmail, password: password)
        let data = try await send(body, to: Config.loginURL)
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }

    // MARK: - Register

    func register(username: String, email: String, password: String, confirmPassword: String) async throws -> AuthResponse {
        let body = RegisterRequest(
            username: username,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        let data = try await send(body, to: Config.registerURL)
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }

    // MARK: - Shared POST

    private func send<T: Encodable>(_ body: T, to url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        // Debug outgoing request
        if let httpBody = request.httpBody,
           let json = String(data: httpBody, encoding: .utf8) {
            print("➡️ [AuthService] POST \(url.absoluteString)")
            print("➡️ Body:", json)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            print("❌ [AuthService] Invalid HTTPURLResponse")
            throw AuthError.invalidResponse
        }

        print("⬇️ [AuthService] Status:", http.statusCode)
        if let text = String(data: data, encoding: .utf8) {
            print("⬇️ [AuthService] Response:", text)
        }

        guard (200..<300).contains(http.statusCode) else {
            if let apiError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data),
               let message = apiError.message,
               !message.isEmpty {
                throw AuthError.server(message)
            } else {
                let fallback = HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
                throw AuthError.server(fallback.capitalized)
            }
        }

        return data
    }
}
