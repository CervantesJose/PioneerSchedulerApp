//
//  AppState.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/26/25.
//

import SwiftUI

@Observable
final class AppState {

    enum AuthState {
        case loading
        case authenticated
        case unathenticated
    }

    var isAuthenticated: AuthState = .loading

    @MainActor
    func checkLoginStatus() async {
        for await state in supabase.auth.authStateChanges {
            if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                withAnimation {
                    isAuthenticated = (state.session != nil) ? .authenticated : .unathenticated
                }
            }
        }
    }
}

extension AppState {
    static func preview() -> AppState {
        let state = AppState()
        state.isAuthenticated = .authenticated
        return state
    }
}
