import Foundation

final class AuthStorage {
    private static let tokenKey = "jwt_token"
    
    static var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set {
            if let value = newValue {
                UserDefaults.standard.setValue(value, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
