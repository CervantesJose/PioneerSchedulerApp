//
//  TimesheetDetailView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/30/25.
//

import SwiftUI

struct TimesheetDetailView: View {
    @Environment(\.dismiss) var dismiss
    let timesheet: Timesheet
    @EnvironmentObject var viewModel: TimesheetViewModel

    @State private var editedTitle = ""
    @State private var editedDescription = ""
    @State private var editedDate: Date? = nil

    var body: some View {
        Form {

            Section(header: Text("Title")) {
                TextField(editedTitle, text: $editedTitle)
                    .backgroundStyle(.regularMaterial)
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

            Section(header: Text("Dates worked")) {
                if let dates = timesheet.workDates {
                    let formattedDates = dates
                        .map { $0.formatted(date: .abbreviated, time: .omitted) }
                        .joined(separator: ", ")

                    Text("\(formattedDates)")
                } else {
                    Text("No dates selected")
                }
            }

            // TODO
            // Datepicker to come
        }
        .onAppear {
            if editedTitle.isEmpty && editedDescription.isEmpty {
                editedTitle = timesheet.title
                editedDescription = timesheet.description ?? ""
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await viewModel.updateTimesheet(
                            id: timesheet.id,
                            title: editedTitle,
                            description: editedDescription,
                            workDates: editedDate.map { [$0] }
                        )
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TimesheetDetailView(
        timesheet: Timesheet(
            id: UUID(),
            title: "This is an example title",
            isComplete: false,
            userId: UUID(),
            createdAt: Date()
        )
    )
    .environmentObject(TimesheetViewModel.preview())
}
