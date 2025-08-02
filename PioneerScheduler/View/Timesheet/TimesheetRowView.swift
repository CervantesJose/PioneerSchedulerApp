//
//  TimesheetRowView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import SwiftUI

struct TimesheetRowView: View {
    @Binding var entry: TimesheetEntry
    @State private var descriptions: [String] = [""]

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Date", selection: $entry.date, displayedComponents: .date)

            ForEach(descriptions.indices, id: \.self) { index in
                TextField("Task description", text: $descriptions[index])
                    .pioneerTextField()
            }

            Button("Add task") {
                descriptions.append("")
            }

            HStack {
                DatePicker("Start", selection: $entry.timeStart, displayedComponents: .hourAndMinute)
                DatePicker("End", selection: $entry.timeEnd, displayedComponents: .hourAndMinute)
            }

            Text("Time worked: \(entry.totalTimeFormatted)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .cornerRadius(10)
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var timesheet = TimesheetEntry()
        var body: some View {
            TimesheetRowView(entry: $timesheet)
        }
    }

    return Preview()
}
