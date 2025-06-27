//
//  ContentView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        Group {
            switch appState.isAuthenticated {
            case .loading:
                ProgressView("Loading...")
            case .authenticated:
                TimesheetView(viewModel: TimesheetViewModel(), authViewModel: AuthViewModel(appState: appState))
            case .unathenticated:
                LoginView(viewModel: AuthViewModel(appState: appState))
            }
        }
        .onAppear {
            Task {
                await appState.checkLoginStatus()
            }
        }
    }
}

#Preview {
    ContentView()
}
