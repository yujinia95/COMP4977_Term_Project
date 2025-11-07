// Views/Menu/UserMenuView.swift
import SwiftUI

struct UserMenuView: View {
    var body: some View {
        ZStack {
            PastelStripeBackground()

            VStack(spacing: AppTheme.vSpacing) {
                // Card header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Menu")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.black.opacity(0.9))
                    Text("Pick an option")
                        .foregroundStyle(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card content (UI-only buttons)
                VStack(spacing: 12) {
                    NavigationLink {
                    } label: {
                        Label("AR Color", systemImage: "camera.viewfinder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(FilledButtonStyle())

                    NavigationLink {
                    } label: {
                        Label("Saved Colors", systemImage: "paintpalette")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OutlineButtonStyle())

                    // Logout visual only (no-op)
                    Button {
                        // design-only
                    } label: {
                        Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OutlineButtonStyle())
                    .tint(.red)
                    .foregroundStyle(.red.opacity(0.9))
                }
            }
            .padding(AppTheme.hPadding)
            .padding(.vertical, 24)
            .background(.white.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.black.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 20, y: 12)
            .padding(.horizontal, AppTheme.hPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        // keep nav bar hidden for the clean full-bleed look (like Login/Signup)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview("Menu • Light") {
    NavigationStack { UserMenuView() }
}

#Preview("Menu • Dark") {
    NavigationStack { UserMenuView() }
        .preferredColorScheme(.dark)
}
