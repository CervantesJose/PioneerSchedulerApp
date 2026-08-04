import SwiftUI

struct CreateTimesheetView: View {

    @Environment(TimesheetViewModel.self) private var viewModel
    @State private var startDate: Date = (Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.start ?? .now)
    @State private var endDate: Date = (
        Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.end.addingTimeInterval(-1) ?? .now
    )

    // Draft workdays edited before the timesheet exists. Each `timesheetId` is a
    // placeholder — addTimesheet stamps the real id once the timesheet is inserted.
    @State private var workdays: [Workday] = [Workday(timesheetId: UUID())]
    @State private var isSaving = false
    @FocusState private var isTaskFieldFocused: Bool

    var body: some View {
        Form {
            Section("Week of:") {
                HStack {
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()

                    Spacer()

                    DatePicker("End date", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
                }
            }

            ForEach($workdays) { $workday in
                Section {
                    WorkdayView(
                        workday: $workday,
                        isTaskFieldFocused: $isTaskFieldFocused,
                        onDeleteWorkday: { deleteWorkday(id: workday.id) }
                    )
                }
            }

            Section {
                Button {
                    withAnimation {
                        addWorkday()
                    }
                } label: {
                    Label("Add Workday", systemImage: "text.pad.header.badge.plus")
                        .buttonStyle(.borderless)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderless)
            }

            Section {
                Button {
                    save()
                } label: {
                    Label("Save Timesheet", systemImage: "bookmark.fill")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderless)
                .disabled(isSaving)
            }
        }
        .navigationTitle("Create Timesheet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.toggleIsCreatingNewItemSheetPresented()
                }
                .disabled(isSaving)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save()
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTaskFieldFocused = false
                }
            }
        }
    }

    private func addWorkday() {
        workdays.append(Workday(timesheetId: UUID()))
    }

    private func deleteWorkday(id: UUID) {
        workdays.removeAll { $0.id == id }
    }

    private func save() {
        guard isSaving == false else { return }
        isSaving = true
        isTaskFieldFocused = false
        Task {
            await viewModel.addTimesheet(startDate: startDate, endDate: endDate, workdays: workdays)
            isSaving = false
        }
    }
}

#Preview {
    NavigationStack {
        CreateTimesheetView()
            .environment(TimesheetViewModel.preview())
    }
}
