//
//  CreateTimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/9/25.
//

import SwiftUI

struct CreateTimesheetView: View {
    @EnvironmentObject var viewModel: TimesheetViewModel
    @State private var startDate: Date = .now
    @State private var endDate: Date = Date(timeIntervalSinceNow: 186000)

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {
                Section("Week of:") {
                    HStack {
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                    }
                }

                Section("Entries") {
                    List($viewModel.entries) { $entry in
                        TimesheetRowView(entry: $entry)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        viewModel.removeEntry
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .listStyle(.plain)
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
        .onAppear {
            viewModel.addEntry()
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

#Preview {
    NavigationStack {
        CreateTimesheetView()
            .environmentObject(TimesheetViewModel.preview())
    }
}
