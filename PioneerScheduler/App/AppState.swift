import SwiftUI

@MainActor
@Observable
final class AppState {

    enum AuthState {
        case loading
        case authenticated
        case unauthenticated
    }

    var authState: AuthState = .loading

    /// Listens to Supabase auth-state changes for the lifetime of the app and
    /// keeps `authState` in sync. This is a long-running stream, so it should be
    /// started exactly once (from the root view).
    func checkLoginStatus() async {
        for await state in supabase.auth.authStateChanges {
            if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                withAnimation {
                    authState = (state.session != nil) ? .authenticated : .unauthenticated
                }
            }
        }
    }
}

extension AppState {
    static func preview() -> AppState {
        let state = AppState()
        state.authState = .authenticated
        return state
    }
}
