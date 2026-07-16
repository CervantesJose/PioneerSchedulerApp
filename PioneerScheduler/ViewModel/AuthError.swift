import Foundation

/// Errors surfaced by `AuthViewModel` during authentication flows.
enum AuthError: LocalizedError {
    case appleCredentialUnavailable

    var errorDescription: String? {
        switch self {
        case .appleCredentialUnavailable:
            "There was an error signing in with the given Apple ID credentials."
        }
    }
}
