//
//  WorkdayView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import SwiftUI

struct WorkdayView: View {
    @Binding var workday: Workday

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Date", selection: $workday.date, displayedComponents: .date)

            ForEach(workday.task.indices, id: \.self) { index in
                HStack {
                    TextField("Task", text: $workday.task[index])
                        .pioneerTextField()

                    Menu {
                        Button(role: .destructive) {
                            workday.task.remove(at: index)
                        } label: {
                            Label("Delete task", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.headline)
                            .padding(.trailing, 8)
                    }
                }
            }

            Button("Add task") {
                workday.task.append("")
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.ultraThinMaterial)
            .contentShape(Rectangle())

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
            WorkdayView(workday: $workday)
        }
    }

    return Preview()
}
