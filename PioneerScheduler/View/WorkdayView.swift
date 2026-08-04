import SwiftUI

struct WorkdayView: View {
    @Binding var workday: Workday
    var isTaskFieldFocused: FocusState<Bool>.Binding
    var onDeleteWorkday: () -> Void

    var body: some View {
        DatePicker("Date", selection: $workday.date, displayedComponents: .date)

        ForEach($workday.tasks) { $task in
            TextField("Task", text: $task.text, axis: .vertical)
                .lineLimit(1...3)
                .focused(isTaskFieldFocused)
                .pioneerTextField()
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteTask(task)
                    } label: {
                        Label("Delete task", systemImage: "trash")
                    }
                }
        }

        Button {
            workday.addTask()
        } label: {
            Label("Add task", systemImage: workday.tasks.isEmpty ? "plus" : "text.append")
        }
        .pioneerButtonStyle()

        HStack(spacing: 32) {
            DatePicker("Start:", selection: $workday.timeStart, displayedComponents: .hourAndMinute)
            DatePicker("End:", selection: $workday.timeEnd, displayedComponents: .hourAndMinute)
        }

        HStack {
            Text("Time worked: \(workday.duration.asHourMinuteString)")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()

            Menu {
                Button(role: .destructive) {
                    onDeleteWorkday()
                } label: {
                    Label("Delete workday", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Workday options")
        }
    }

    private func deleteTask(_ task: TaskItem) {
        isTaskFieldFocused.wrappedValue = false
        workday.deleteTask(task)
    }
}

#Preview {
    @Previewable @State var workday = Workday.mockWorkDay()
    @Previewable @FocusState var isFocused: Bool

    Form {
        Section {
            WorkdayView(workday: $workday, isTaskFieldFocused: $isFocused, onDeleteWorkday: {})
        }
    }
}
