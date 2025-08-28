//
//  TimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import SwiftUI

struct TimesheetView: View {

    @EnvironmentObject var viewModel: TimesheetViewModel
    var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    loadingView
                case .loaded:
                    if viewModel.timesheets.isEmpty {
                        emptyView
                    } else {
                        listView
                    }
                case .failed(let error):
                    Text("Failed to load timesheets: \(error.localizedDescription)")
                }
            }
            .navigationTitle("Timesheets")
            .toolbarBackground(Color("backgroundColor").opacity(0.2), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .task {
                if case .idle = viewModel.state {
                    await viewModel.fetchTimesheets()
                }
            }
            .refreshable {
                await viewModel.fetchTimesheets()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        authViewModel.handleSignOut()
                    } label: {
                        Text("Sign out")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.toggleIsCreatingNewItemSheetPresented()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(Circle())
                }
            }
            .sheet(isPresented: $viewModel.isCreatingNewItemSheetPresented) {
                NavigationStack {
                    CreateTimesheetView()
                        .environmentObject(viewModel)
                        .presentationDetents([.fraction(0.35)])
                }
            }
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        ProgressView("Loading timesheets")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var emptyView: some View {
        VStack {
            Spacer()
            Button {
                viewModel.toggleIsCreatingNewItemSheetPresented()
            } label: {
                Text("Create a timesheet")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private var listView: some View {
        List(viewModel.timesheets) { timesheet in
            NavigationLink(value: timesheet) {
                timesheetRow(timesheet: timesheet)
            }
            .listRowInsets(EdgeInsets())
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteTimesheet(id: timesheet.id)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .navigationDestination(for: TimesheetWithWorkdays.self) { timesheet in
            TimesheetDetailView(timesheet: timesheet) { hydrated in
                viewModel.apply(hydrated: hydrated)
            }
        }
    }

    private func timesheetRow(timesheet: TimesheetWithWorkdays) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(
                    "\(timesheet.startDate.formatted(date: .abbreviated, time: .omitted)) - \(timesheet.endDate.formatted(date: .abbreviated, time: .omitted))"
                )
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
            }

            Spacer()

            VStack {
                Text("Total")
                Text((timesheet.workday).reduce(0) { $0 + $1.duration }.asHourMinuteString)
                    .font(.body)
            }
        }
        .padding()
    }
}

#Preview {
    TimesheetView(authViewModel: .preview())
        .environmentObject(TimesheetViewModel.preview())
}
