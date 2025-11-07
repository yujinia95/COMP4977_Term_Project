import SwiftUI

struct SignupView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            PastelStripeBackground()

            VStack(spacing: AppTheme.vSpacing) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create account")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.black.opacity(0.9))
                    Text("Join Aurora Color")
                        .foregroundStyle(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    TextField("Name", text: $name).authField()
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .authField()
                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                        .authField()
                }

                Button { /* UI only */ } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(FilledButtonStyle())
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
            .navigationTitle("Sign Up")
        }
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack { SignupView() }
                .previewDisplayName("Signup • Light")
            NavigationStack { SignupView() }
                .preferredColorScheme(.dark)
                .previewDisplayName("Signup • Dark")
        }
    }
}
