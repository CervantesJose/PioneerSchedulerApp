import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var timesheetsViewModel = TimesheetViewModel()

    var body: some View {
        Group {
            switch appState.authState {
            case .loading:
                ProgressView("Loading…")
            case .authenticated:
                TimesheetView(authViewModel: AuthViewModel(appState: appState))
                    .environment(timesheetsViewModel)
            case .unauthenticated:
                LoginView(viewModel: AuthViewModel(appState: appState))
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
