//
//  CreateTimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/9/25.
//

import SwiftUI

struct CreateTimesheetView: View {
    @EnvironmentObject var viewModel: TimesheetViewModel
    @State private var selectedRange: DateRange?

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {
                Section("Title") {
                    TextField("Enter title", text: $viewModel.newTimesheetTitle)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                ForEach($viewModel.entries) { $entry in
                    TimesheetRowView(entry: $entry)
                }
                .contentShape(Rectangle())
                .swipeActions(edge: .leading) {
                    Button(role: .destructive) {
                        Task {
                            viewModel.removeEntry
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }

                Button(action: {
                    viewModel.addEntry()
                }) {
                    Label("Add New Entry", systemImage: "plus")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }

                Spacer()

                Button {
                    Task {
                        await viewModel
                            .addTimesheet(
                                title: viewModel.newTimesheetTitle,
                                description: viewModel.entries.first?.taskDescription,
                                workDates: [viewModel.newTimesheetDate]
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
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.toggleIsCreatingNewItemSheetPresented()
                }
            }
        }
    }
}

struct CreateTimesheetView_Previews: PreviewProvider {
    static let timesheetViewModel = TimesheetViewModel()
    static var previews: some View {
        NavigationStack {
            CreateTimesheetView()
                .environmentObject(timesheetViewModel)
        }
    }
}
