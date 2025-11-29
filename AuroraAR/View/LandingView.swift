import SwiftUI

struct LandingView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLogin = false
    var body: some View {
        ZStack {
            PastelStripeBackground()

            VStack {
                Spacer()

                VStack(spacing: AppTheme.vSpacing) {
                    VStack(spacing: 8) {
                        Text("Aurora Color")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .kerning(0.5)
                            .foregroundStyle(.black.opacity(0.85))

                        Text("Tap the camera to find colors.\nLog in or sign up to meet your colors.")
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .foregroundStyle(.black.opacity(0.65))
                    }

                    VStack(spacing: 12) {
                        Button { showLogin = true } label: { Text("Log In") }
                            .buttonStyle(FilledButtonStyle())

                        NavigationLink { SignupView() } label: {
                            Text("Sign Up")
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }
                    .padding(.horizontal, AppTheme.hPadding)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.hPadding)

                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            NavigationStack {
                LoginView()
                    .environmentObject(appState)
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack { LandingView() }
                .previewDisplayName("Landing • Light")
        }
    }
}
