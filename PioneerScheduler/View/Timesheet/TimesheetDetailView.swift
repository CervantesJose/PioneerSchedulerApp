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

            Section(header: Text("Description")) {
                TextEditor(text: $editedDescription)
                    .frame(minHeight: 100, maxHeight: 200)
                    .backgroundStyle(.regularMaterial)
            }

            Section(header: Text("Dates worked")) {
                Text("\(timesheet.workDates ?? [])")
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
