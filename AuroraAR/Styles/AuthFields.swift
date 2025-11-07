import SwiftUI

struct AuthFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
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
