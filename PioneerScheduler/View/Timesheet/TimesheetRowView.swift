//
//  TimesheetRowView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import SwiftUI

struct TimesheetRowView: View {
    @Binding var entry: TimesheetEntry

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Date", selection: $entry.date, displayedComponents: .date)

            TextField("Description", text: $entry.taskDescription)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            HStack {
                DatePicker("Start", selection: $entry.timeStart, displayedComponents: .hourAndMinute)
                DatePicker("End", selection: $entry.timeEnd, displayedComponents: .hourAndMinute)
            }

            Text("Time worked: \(entry.totalTimeFormatted)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .cornerRadius(10)

            HStack {
                Spacer()

                Button("Add Photos") {
                    // Show Photos
                }
                .buttonStyle(.borderedProminent)
                Button("Show photos") {
                    // camera
                }
                .buttonStyle(.bordered)

                Spacer()
            }
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
