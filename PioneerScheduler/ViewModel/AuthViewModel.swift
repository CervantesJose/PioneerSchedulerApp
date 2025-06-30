//
//  AuthenticationViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/23/25.
//

import AuthenticationServices
import Supabase
import SwiftUI

@MainActor
@Observable
final class AuthViewModel {

    private var timesheetViewModel = TimesheetViewModel()

    var userEmail = ""
    var userPassword = ""
    var isAuthenticated = false

    var isLoading = false
    var isShowingAlert = false
    var alertTitle = ""
    var alertMessage = ""

    var authResult: Result<Void, Error>? {
        didSet {
            if case .failure(let error) = authResult {
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

    func toggleLoadingState() {
        withAnimation {
            isLoading.toggle()
        }
    }

    // MARK: Authentication methods

    // Login with email
    func handleSignInButtonTapped() {
        guard isValid else {
            alertTitle = "Login Failed"
            alertMessage = "Please enter correct email and/or password"
            showAlert()
            return
        }

        let newViewModel = TimesheetViewModel()
        self.timesheetViewModel = newViewModel

        Task {
            await signIn()
        }
    }

    @MainActor
    private func signIn() async {
        toggleLoadingState()

        defer { toggleLoadingState() }

        do {
            try await supabase.auth.signIn(
                email: userEmail,
                password: userPassword
            )
            authResult = .success(())

            appState.isAuthenticated = .loading
            await appState.checkLoginStatus()
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
            isAuthenticated = false
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
        toggleLoadingState()

        defer { toggleLoadingState() }

        let newViewModel = TimesheetViewModel()
        self.timesheetViewModel = newViewModel

        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            authResult = .failure("There was an error signing in with given Apple ID credentials" as! Error)
            return
        }

        do {
            try await supabase.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: identityToken))
            authResult = .success(())
            appState.isAuthenticated = .loading
            await appState.checkLoginStatus()
            await timesheetViewModel.fetchTimesheets()
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

    @MainActor
    private func register() async {
        toggleLoadingState()
        
        defer {
            toggleLoadingState()
        }
        
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
        alertTitle = "Registration failed"
        alertMessage = "Please enter valid email and/or password."
        showAlert()
    }
}
