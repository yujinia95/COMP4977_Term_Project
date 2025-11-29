import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LoginViewModel()
    @State private var showErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                PastelStripeBackground()
                
                VStack(spacing: AppTheme.vSpacing) {
                    
                    // Back Button
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.8))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                        }
                        
                        Spacer()
                    }
                    
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
                        TextField("Email or username", text: $viewModel.usernameOrEmail)
                            .textContentType(.username)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .authField()
                        
                        SecureField("Password", text: $viewModel.password)
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
                                dismiss()   // go back after successful login
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
                        .foregroundStyle(Color.pastelBlue)
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                }
                .padding(AppTheme.hPadding)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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

