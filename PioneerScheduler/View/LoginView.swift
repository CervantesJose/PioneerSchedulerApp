import AuthenticationServices
import SwiftUI

struct LoginView: View {

    @Bindable var viewModel: AuthViewModel

    var body: some View {

        NavigationStack {

            ZStack {

                BackgroundView()
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.userEmail)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.ultraThickMaterial)
                        .clipShape(.rect(cornerRadius: 8))

                    SecureField("Password", text: $viewModel.userPassword)
                        .textContentType(.password)
                        .padding()
                        .background(.ultraThickMaterial)
                        .clipShape(.rect(cornerRadius: 8))

                    Button {
                        viewModel.handleSignInButtonTapped()
                    } label: {
                        Text("Login")
                            .pioneerButtonStyle()
                            .padding(.top)
                    }
                    .alert(viewModel.alertTitle, isPresented: $viewModel.isShowingAlert, actions: {
                        Button("OK", role: .cancel) { }
                    }, message: {
                        Text(viewModel.alertMessage)
                    })

                    Button {
                        viewModel.handleRegisterButtonTapped()
                    } label: {
                        Text("Register with Email")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 44)

                    }

                    OrSeparatorView()

                    SignInWithAppleButton { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        viewModel.handleWithAppleButtonTapped(result: result)
                    }
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 44)
                    .padding()
                }
                .navigationTitle("Pioneer Timesheets")
                .padding()
            }
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel.preview())
}
