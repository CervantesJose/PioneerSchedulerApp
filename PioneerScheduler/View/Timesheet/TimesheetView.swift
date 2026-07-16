//
//  TimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import SwiftUI

struct TimesheetView: View {

    @Environment(TimesheetViewModel.self) private var viewModel
    var authViewModel: AuthViewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        return NavigationStack {
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
                    Button("Sign out") {
                        authViewModel.handleSignOut()
                    }
                    .font(.headline)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("New timesheet", systemImage: "plus") {
                        viewModel.toggleIsCreatingNewItemSheetPresented()
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderedProminent)
                    .clipShape(Circle())
                }
            }
            .sheet(isPresented: $viewModel.isCreatingNewItemSheetPresented) {
                NavigationStack {
                    CreateTimesheetView()
                        .environment(viewModel)
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
                    .clipShape(.rect(cornerRadius: 10))
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
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .animation(.default, value: viewModel.timesheets)
    }

    private func timesheetRow(timesheet: TimesheetWithWorkdays) -> some View {
        HStack {
            VStack {
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
        .environment(TimesheetViewModel.preview())
}
