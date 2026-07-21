import SwiftUI

@main
struct PioneerSchedulerApp: App {

    private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
