import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LoginViewModel()
    @State private var showErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
                PastelStripeBackground()
                
                VStack(spacing: AppTheme.vSpacing) {
                    // (removed custom in-view Back button)
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back")
                            .font(.title.weight(.bold))
                            .foregroundStyle(.black.opacity(0.9))
                        
                        Text("Log in to continue")
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Login form
                    VStack(spacing: 12) {
                        TextField("", text: $viewModel.usernameOrEmail)
                            .placeholder("Email or username", show: viewModel.usernameOrEmail.isEmpty)
                            .textContentType(.username)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .authField()
                        
                        SecureField("", text: $viewModel.password)
                            .placeholder("Password", show: viewModel.password.isEmpty)
                            .textContentType(.password)
                            .authField()
                    }
                    
                    // Error text
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Login button
                    Button {
                        Task {
                            if let auth = await viewModel.login() {
                                // New authentication + authorization flow
                                appState.setSession(token: auth.token, user: auth.user)
                                // Dismiss back to the root so RootView can switch to UserMenuView
                                dismiss()
                            } else {
                                showErrorAlert = true
                            }
                        }
                    } label: {
                        Text(viewModel.isLoading ? "Logging in…" : "Log in")
                    }
                    .buttonStyle(FilledButtonStyle())
                    .disabled(viewModel.isLoading)
                    
                    // Link to signup
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.black.opacity(0.6))
                        
                        NavigationLink("Sign up") {
                            SignupView()
                        }
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Color.black)
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                }
                .padding(AppTheme.hPadding)
            }
        
        .alert("Login failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
}

#Preview("Login • Light") {
    NavigationStack { LoginView() }
        .environmentObject(AppState())
}

