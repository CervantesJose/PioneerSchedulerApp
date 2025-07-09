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
        List {
            ForEach(viewModel.timesheets, id: \.id) { timesheet in
                NavigationLink(value: timesheet) {
                    timesheetRow(timesheet: timesheet)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .swipeActions(edge: .leading) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.deleteTimesheet(id: timesheet.id)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if timesheet.isComplete == false {
                        Button {
                            Task {
                                await viewModel.markAsCompleted(id: timesheet.id)
                            }
                        } label: {
                            Label("Complete", systemImage: "checkmark.circle")
                        }
                        .tint(.green)
                    } else {
                        Button {
                            Task {
                                await viewModel.markAsIncomplete(id: timesheet.id)
                            }
                        } label: {
                            Label("Incomplete", systemImage: "x.circle")
                        }
                        .tint(.orange)
                    }
                }
            }
        }
        .navigationDestination(for: Timesheet.self) { timesheet in
            TimesheetDetailView(timesheet: timesheet)
        }
    }

    private func timesheetRow(timesheet: Timesheet) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                Text(timesheet.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer()

                if timesheet.isComplete {
                    Text("Completed")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .padding(8)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                } else {
                    Text("Pending")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            .padding(.leading)

            Text("\(timesheet.createdAt, style: .date)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading)

            if let description = timesheet.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
            }

            SeparatorView()
        }
    }
}

#Preview {
    TimesheetView(authViewModel: .preview())
        .environmentObject(TimesheetViewModel.preview())
}
