import SwiftUI

struct SignupView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = SignupViewModel()
    @State private var showErrorAlert = false
    @State private var navigateToLogin = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
                    Text("Create account")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.black.opacity(0.9))
                    Text("Sign up to get started")
                        .foregroundStyle(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink(isActive: $navigateToLogin) {
                    LoginView()
                } label: { EmptyView() }
                .hidden()

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
                }

                // Error text
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Sign up button
                Button {
                    Task {
                        let success = await viewModel.signUp()
                        if success {
                            // After successful signup, navigate to Login
                            navigateToLogin = true
                        } else {
                            showErrorAlert = true
                        }
                    }
                } label: {
                    Text(viewModel.isLoading ? "Creating account…" : "Sign up")
                }
                .buttonStyle(FilledButtonStyle())
                .disabled(viewModel.isLoading)

                // Link back to login
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
        .toolbar(.hidden, for: .navigationBar)
        .alert("Sign up failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
}

#Preview("Signup • Light") {
    NavigationStack { SignupView() }
        .environmentObject(AppState())
}

