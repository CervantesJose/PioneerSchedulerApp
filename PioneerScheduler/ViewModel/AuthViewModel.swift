import AuthenticationServices
import Supabase
import SwiftUI

@MainActor
@Observable
final class AuthViewModel {

    private enum Constants {
        static let loginFailedTitle = "Login Failed"
        static let loginFailedMessage = "Please enter correct email and/or password"
        static let authErrorTitle = "Authentication Failed"
        static let registrationFailedTitle = "Registration failed"
        static let registrationFailedMessage = "Please enter valid email and/or password."
    }

    var userEmail = ""
    var userPassword = ""

    var isLoading = false
    var isShowingAlert = false
    var alertTitle = ""
    var alertMessage = ""

    var authResult: Result<Void, Error>? {
        didSet {
            if case .failure(let error) = authResult {
                alertTitle = Constants.authErrorTitle
                alertMessage = error.localizedDescription
                showAlert()
            }
        }
    }

    var isValid: Bool {
        !userEmail.isEmpty && !userPassword.isEmpty
    }

    let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    func showAlert() {
        isShowingAlert = true
    }

    private func setLoading(_ value: Bool) {
        withAnimation {
            isLoading = value
        }
    }

    // MARK: Authentication methods

    // Login with email
    func handleSignInButtonTapped() {
        guard isValid else {
            alertTitle = Constants.loginFailedTitle
            alertMessage = Constants.loginFailedMessage
            showAlert()
            return
        }

        Task {
            await signIn()
        }
    }

    private func signIn() async {
        setLoading(true)
        defer { setLoading(false) }

        do {
            try await supabase.auth.signIn(
                email: userEmail,
                password: userPassword
            )
            authResult = .success(())
            // The auth-state listener in AppState reacts to the sign-in event
            // and updates the root view; no further work is needed here.
        } catch {
            authResult = .failure(error)
        }
    }

    // Log out
    func handleSignOut() {
        Task {
            await signOut()
        }
    }

    private func signOut() async {
        do {
            try await supabase.auth.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: Sign in with Apple
    func handleWithAppleButtonTapped(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                Task {
                    await signInWithApple(credential: appleIdCredential)
                }
            }

        case .failure(let error):
            authResult = .failure(error)
        }
    }

    private func signInWithApple(credential: ASAuthorizationAppleIDCredential) async {
        setLoading(true)
        defer { setLoading(false) }

        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            authResult = .failure(AuthError.appleCredentialUnavailable)
            return
        }

        do {
            try await supabase.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: identityToken))
            authResult = .success(())
        } catch {
            authResult = .failure(error)
        }
    }

    // MARK: Registering with email

    func handleRegisterButtonTapped() {
        guard isValid else {
            registrationError()
            return
        }

        Task {
            await register()
        }
    }

    private func register() async {
        setLoading(true)
        defer { setLoading(false) }

        do {
            try await supabase.auth.signUp(
                email: userEmail,
                password: userPassword
            )

            await signIn()
        } catch {
            registrationError()
        }
    }

    func registrationError() {
        alertTitle = Constants.registrationFailedTitle
        alertMessage = Constants.registrationFailedMessage
        showAlert()
    }
}

extension AuthViewModel {
    static func preview() -> AuthViewModel {
        AuthViewModel(appState: .preview())
    }
}
