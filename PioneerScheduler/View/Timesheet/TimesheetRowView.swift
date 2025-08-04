//
//  TimesheetRowView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import SwiftUI

struct TimesheetRowView: View {
    @Binding var workday: Workday
    @State private var descriptions: [String] = [""]

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Date", selection: $workday.date, displayedComponents: .date)

            ForEach(descriptions.indices, id: \.self) { index in
                TextField("Task description", text: $descriptions[index])
                    .pioneerTextField()
            }

            Button("Add task") {
                descriptions.append("")
            }

            HStack {
                DatePicker("Start", selection: $workday.timeStart, displayedComponents: .hourAndMinute)
                DatePicker("End", selection: $workday.timeEnd, displayedComponents: .hourAndMinute)
            }

            Text("Time worked: \(workday.timeWorked)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .cornerRadius(10)
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var timesheet = Workday()
        var body: some View {
            TimesheetRowView(workday: $timesheet)
        }
    }

    return Preview()
}
