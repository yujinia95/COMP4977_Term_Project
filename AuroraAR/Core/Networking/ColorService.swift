import Foundation


private struct ServerErrorResponse: Decodable {
    let message: String?
}


final class ColorService {
    static let shared = ColorService()
    private init() {}
    
    
    func AddColor(colorName: String, colorCode: String) async throws -> ColorResponse {
        let body = ColorResponse(colorName: colorName, colorCode: colorCode)
        let data = try await sendPost(body, to: Config.colorsURL)
        return try JSONDecoder().decode(ColorResponse.self, from: data)
    }
    
    
    func GetColors() async throws -> [ColorRequest] {
        let data = try await sendGet(from: Config.colorsURL)
        return try JSONDecoder().decode([ColorRequest].self, from: data)
    }
    
    
    func GetColorById(colorId: Int) async throws -> ColorResponse {
        let body = ColorById(ColorId: colorId)
        let data = try await sendPost(body, to: Config.colorByIDURL(colorId))
        return try JSONDecoder().decode(ColorResponse.self, from: data)
    }
    
    func DeleteColor(colorId: Int) async throws {
        _ = try await sendDeleteNoBody(to: Config.colorByIDURL(colorId))
    }
    
    
    
    
    
    
    private func sendPost<T: Encodable>(_ body: T, to url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        if let token = AuthStorage.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Debug outgoing request
        if let httpBody = request.httpBody,
           let json = String(data: httpBody, encoding: .utf8) {
            print("➡️ [ColorService] POST \(url.absoluteString)")
            print("➡️ Body:", json)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            print("❌ [ColorService] Invalid HTTPURLResponse")
            throw AuthError.invalidResponse
        }

        print("⬇️ [ColorService] Status:", http.statusCode)
        if let text = String(data: data, encoding: .utf8) {
            print("⬇️ [ColorService] Response:", text)
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
    
    private func sendGet(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = AuthStorage.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        print("➡️ [ColorService] GET \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            print("❌ [ColorService] Invalid HTTPURLResponse")
            throw AuthError.invalidResponse
        }

        print("⬇️ [ColorService] Status:", http.statusCode)
        if let text = String(data: data, encoding: .utf8) {
            print("⬇️ [ColorService] Response:", text)
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
    
    
    private func sendDeleteNoBody(to url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = AuthStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        print("➡️ [ColorService] DELETE \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw AuthError.server("Delete failed")
        }

        return data
    }


    
}

