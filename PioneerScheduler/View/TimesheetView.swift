//
//  TimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import SwiftUI

struct TimesheetView: View {

    @Bindable var viewModel = TimesheetViewModel()
    var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.timesheets) { timesheet in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(timesheet.title)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Spacer()

                            if timesheet.is_complete {
                                Text("Completed")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                    .padding(8)
                                    .background(Color.green.opacity((0.2)))
                                    .cornerRadius(4)
                            } else {
                                Text("Pending")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .padding(8)
                                    .background(Color.red.opacity((0.2)))
                                    .cornerRadius(4)
                            }
                        }

                        Text("\(timesheet.created_at, style: .date)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let description = timesheet.description, description.isEmpty == false {
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing) {
                        if timesheet.is_complete == false {
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

                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteTimesheet(id: timesheet.id)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchTimesheets()
            }
            .navigationTitle("Timesheets")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        authViewModel.handleSignOut()
                    } label: {
                        Text("Sign out")
                            .padding(.trailing, 240)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.toggleIsCreatingNewItemSheetPresented()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(.circle)
                }
            }
            .sheet(isPresented: $viewModel.isCreatingNewItemSheetPresented) {
                createTimesheetView
                    .presentationDetents([.medium])
            }
        }
    }

    @ViewBuilder
    private var createTimesheetView: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Title")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("Enter title", text: $viewModel.newTimesheetTitle)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("Enter description", text: $viewModel.newTimesheetDescription)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding(.bottom)

                Spacer()

                Button {
                    Task {
                        await viewModel
                            .addTimesheet(
                                title: viewModel.newTimesheetTitle,
                                description: viewModel.newTimesheetDescription
                            )
                    }
                } label: {
                    Text("Save Timesheet")
                        .font(.headline)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.capsule)
                .frame(maxWidth: .infinity)

                Spacer()
            }
        }
        .padding()
        .navigationTitle("Create timesheet")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button("Cancel") {
            viewModel.toggleIsCreatingNewItemSheetPresented()
        })
    }
}

#Preview {
    TimesheetView(viewModel: TimesheetViewModel(), authViewModel: AuthViewModel(appState: AppState()))
}
