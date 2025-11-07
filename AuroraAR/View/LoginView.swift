import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            PastelStripeBackground()

            VStack(spacing: AppTheme.vSpacing) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.black.opacity(0.9))
                    Text("Log in to continue")
                        .foregroundStyle(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .authField()

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .authField()
                }

                Button { /* UI only */ } label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(FilledButtonStyle())

                HStack {
                    Spacer()
                    NavigationLink("Create an account") { SignupView() }
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.black.opacity(0.75))
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
            .navigationTitle("Log In")
        }
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack { LoginView() }
                .previewDisplayName("Login • Light")
            NavigationStack { LoginView() }
                .preferredColorScheme(.dark)
                .previewDisplayName("Login • Dark")
        }
    }
}
