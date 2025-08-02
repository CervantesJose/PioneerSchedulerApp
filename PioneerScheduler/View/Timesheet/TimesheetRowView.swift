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
            HStack {
                DatePicker("Date", selection: $entry.date, displayedComponents: .date)

                Button("Add", systemImage: "photo") {
                    // Show Photos
                }
                .buttonStyle(.borderedProminent)

                Button("Show", systemImage: "photo") {
                    // camera
                }
                .buttonStyle(.bordered)
            }

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
        .onAppear(perform: setTimes)
    }

    func setTimes() {
        var components = DateComponents()
        let calendar = Calendar.current
        components.hour = 8
        let startTime = calendar.date(from: components)
        entry.timeStart = startTime ?? .now
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
