//
//  AuthenticationViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/23/25.
//

import Supabase
import SwiftUI

@Observable
final class AuthViewModel {

    var userEmail = ""
    var userPassword = ""
    var isAuthenticated = false

    var isLoading = false
    var isShowingAlert = false
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

    func handleSignInButtonTapped() {
        guard isValid else {
            alertMessage = "Please enter your email and/or password"
            showAlert()
            return
        }

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
}
