//
//  PioneerSchedulerApp.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

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
