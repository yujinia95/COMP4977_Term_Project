import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8)  / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self = Color(red: r, green: g, blue: b, opacity: opacity)
    }

    static let pastelPink  = Color(hex: "#FCDCE1")
    static let pastelPeach = Color(hex: "#FFE6BB")
    static let pastelMint  = Color(hex: "#CDE9DC")
    static let pastelBlue  = Color(hex: "#C4DFE5")
}
