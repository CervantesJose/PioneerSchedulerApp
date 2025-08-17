//
//  TimesheetDetailView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/30/25.
//

import SwiftUI

struct TimesheetDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TimesheetViewModel

    let timesheet: Timesheet

    @State private var editedDate: Date? = nil

    var body: some View {
        
        Form {
            
            Section("Workdays") {
                ForEach($viewModel.workdays) { $workday in
                    WorkdayView(workday: $workday)
                }
                .onDelete { indexSet in
                    viewModel.workdays.remove(atOffsets: indexSet)
                }

                Button(action: {
                    viewModel.addWorkday()
                }) {
                    Label("Add workday", systemImage: "plus")
                        .pioneerButtonStyle()
                }
            }
            
            Section(header: Text("Total hours")) {
                Text(viewModel.totalDuration.asHourMinuteString)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await viewModel.updateTimesheet(
                            id: timesheet.id
                        )
                    }
                    dismiss()
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
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                totalHours: 0.0,
                workdays: Workday.mockData()
            )
        )
        .environmentObject(TimesheetViewModel.preview())
    }
}
