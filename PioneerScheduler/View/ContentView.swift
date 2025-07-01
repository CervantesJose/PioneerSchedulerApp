//
//  ContentView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var appState
    @StateObject private var timesheetsViewModel = TimesheetViewModel()
    
    var body: some View {
        Group {
            switch appState.isAuthenticated {
            case .loading:
                ProgressView("Loading...")
            case .authenticated:
                TimesheetView(authViewModel: AuthViewModel(appState: appState))
                    .environmentObject(timesheetsViewModel)
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
