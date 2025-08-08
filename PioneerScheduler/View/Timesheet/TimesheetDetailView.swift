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
    @State private var editedDate: Date? = nil

    var body: some View {
        
        Form {
            Section("Title") {
                TextField(editedTitle, text: $editedTitle)
            }
            
            Section("Workdays") {
                List($viewModel.workdays) { $workday in
                    TimesheetRowView(workday: $workday)
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
                
                Button(action: {
                    viewModel.addWorkday()
                }) {
                    Label("Add workday", systemImage: "plus")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }
            }
            
            Section(header: Text("Total hours")) {
                Text("0")
            }
            .onAppear {
                if editedTitle.isEmpty {
                    editedTitle = timesheet.title ?? ""
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.updateTimesheet(
                                id: timesheet.id,
                                title: editedTitle
                            )
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimesheetDetailView(
            timesheet: Timesheet(
                id: UUID(),
                title: "This is an example title",
                userId: UUID(),
                totalHours: 8,
                workdays: Workday.mockData()
            )
        )
        .environmentObject(TimesheetViewModel.preview())
    }
}
