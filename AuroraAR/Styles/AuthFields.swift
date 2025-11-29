import SwiftUI

struct AuthFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            // Force high-contrast text color for form fields so typed text is visible
            .foregroundColor(Color.black.opacity(0.95))
            .frame(height: AppTheme.fieldHeight)
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(.black.opacity(0.08), lineWidth: 1)
            )
    }
}

extension View {
    func authField() -> some View { modifier(AuthFieldStyle()) }
}

extension View {
    /// Overlay a custom placeholder when `show` is true. Designed to be used before `authField()` so styling aligns.
    func placeholder(_ text: String, show: Bool) -> some View {
        ZStack(alignment: .leading) {
            if show {
                Text(text)
                    .foregroundColor(Color.black.opacity(0.45))
                    .padding(.horizontal, 14)
                    .frame(height: AppTheme.fieldHeight)
            }
            self
        }
    }
}
