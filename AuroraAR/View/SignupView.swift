import SwiftUI

struct SignupView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignupViewModel()
    @State private var showErrorAlert = false
    @State private var navigateToLogin = false
    
    var body: some View {
        ZStack {
            PastelStripeBackground()

            VStack(spacing: AppTheme.vSpacing) {
                
                // (removed custom in-view Back button)
                
                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create account")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.black.opacity(0.9))
                    Text("Sign up to get started")
                        .foregroundStyle(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Fields
                VStack(spacing: 12) {
                    TextField("Name", text: $viewModel.username)
                        .textContentType(.name)
                        .authField()

                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .authField()

                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.newPassword)
                        .authField()

                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textContentType(.newPassword)
                        .authField()
                }

                // Error text in UI
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Sign up button
                Button {
                    Task {
                        if let auth = await viewModel.signUp() {
                            // ✅ Save token & user globally
                            appState.setSession(token: auth.token, user: auth.user)

                            // ✅ Go back to RootView; RootView will now show UserMenuView
                            dismiss()
                        }
                    }
                } label: {
                    Text(viewModel.isLoading ? "Creating account…" : "Sign up")
                }
                .buttonStyle(FilledButtonStyle())
                .disabled(viewModel.isLoading)

                // Link back to login (for existing users)
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundStyle(.black.opacity(0.6))
                    NavigationLink("Log in") {
                        LoginView()
                    }
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(Color.pastelBlue)
                }
                .padding(.top, 4)

                Spacer()
            }
            .padding(AppTheme.hPadding)
        }
        
        .alert("Sign up failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }

        // Automatically show alert when ViewModel sets an error
        .onChange(of: viewModel.errorMessage) { newValue in
            if newValue != nil {
                showErrorAlert = true
            }
        }
    }
}

#Preview("Signup • Light") {
    NavigationStack { SignupView() }
        .environmentObject(AppState())
}
