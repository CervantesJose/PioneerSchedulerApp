import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var timesheetsViewModel = TimesheetViewModel()
    // Owned here rather than built inline: a fresh instance on every body pass
    // would drop in-flight state such as `isLoading` and the alert text.
    @State private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            switch appState.authState {
            case .loading:
                ProgressView("Loading…")
            case .authenticated:
                TimesheetView(authViewModel: authViewModel)
                    .environment(timesheetsViewModel)
            case .unauthenticated:
                LoginView(viewModel: authViewModel)
            }
        }
        .task {
            await appState.checkLoginStatus()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState.preview())
}
