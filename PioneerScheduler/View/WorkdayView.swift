//
//  WorkdayView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import SwiftUI

struct WorkdayView: View {
    @Binding var workday: Workday
    var isTaskFieldFocused: FocusState<Bool>.Binding

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Date", selection: $workday.date, displayedComponents: .date)

            ForEach(workday.tasks.indices, id: \.self) { index in
                HStack {
                    TextField("Task", text: $workday.tasks[index], axis: .vertical)
                        .lineLimit(1...3)
                        .focused(isTaskFieldFocused)
                        .pioneerTextField()

                    Menu {
                        Button(role: .destructive) {
                            workday.tasks.remove(at: index)
                        } label: {
                            Label("Delete task", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.headline)
                            .padding(.trailing, 8)
                    }
                    .accessibilityLabel("Task options")
                }
            }

            Button("Add task") {
                workday.tasks.append("")
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.ultraThinMaterial)
            .contentShape(Rectangle())

            HStack {
                DatePicker("Start", selection: $workday.timeStart, displayedComponents: .hourAndMinute)
                DatePicker("End", selection: $workday.timeEnd, displayedComponents: .hourAndMinute)
            }
            
            Text("Time worked: \(workday.duration.asHourMinuteString)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    @Previewable @State var workday = Workday.mockWorkDay()
    @Previewable @FocusState var isFocused: Bool

    WorkdayView(workday: $workday, isTaskFieldFocused: $isFocused)
}
