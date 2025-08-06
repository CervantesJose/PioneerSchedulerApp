//
//  TimesheetRowView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import SwiftUI

struct TimesheetRowView: View {
    @Binding var workday: Workday

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Date", selection: $workday.date, displayedComponents: .date)

            Section("Tasks") {
                ForEach(workday.task.indices, id: \.self) { index in
                    TextField("Task", text: $workday.task[index])
                        .pioneerTextField()
                }
            }

            Button("Add task") {
                workday.task.append("")
            }

            HStack {
                DatePicker("Start", selection: $workday.timeStart, displayedComponents: .hourAndMinute)
                DatePicker("End", selection: $workday.timeEnd, displayedComponents: .hourAndMinute)
            }
            Text("Time worked: \(String(format: "%.2f", workday.timeWorked ?? 0))")
                .font(.footnote)
                .foregroundColor(.secondary)
                .cornerRadius(10)
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var workday = Workday.mockWorkDay()

        var body: some View {
            TimesheetRowView(workday: $workday)
        }
    }

    return Preview()
}
