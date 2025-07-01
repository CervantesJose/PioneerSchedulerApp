//
//  TimesheetDetailView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/30/25.
//

import SwiftUI

struct TimesheetDetailView: View {
    let timesheet: Timesheet
    @EnvironmentObject var viewModel: TimesheetViewModel

    var body: some View {
        Text(timesheet.title)
    }
}

#Preview {
    TimesheetDetailView(
        timesheet: Timesheet(
            id: UUID(),
            title: "This is an example title",
            isComplete: false,
            userId: UUID(),
            workday: Date()
        )
    )
    .environmentObject(TimesheetViewModel())
}
