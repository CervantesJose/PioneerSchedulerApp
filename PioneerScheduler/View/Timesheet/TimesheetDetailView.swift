import SwiftUI

struct TimesheetDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: DetailViewModel
    let onSave: (TimesheetWithWorkdays) -> Void
    let timesheet: TimesheetWithWorkdays

    @State private var isShowingExportAlert = false
    @State private var isSaving = false
    @State private var isShowingUnsavedChangesAlert = false
    @FocusState private var isTaskFieldFocused: Bool

    init(timesheet: TimesheetWithWorkdays, onSave: @escaping (TimesheetWithWorkdays) -> Void) {
        self.timesheet = timesheet
        _viewModel = State(initialValue: DetailViewModel(timesheet: timesheet))
        self.onSave = onSave
    }

    private var title: String {
        "\(timesheet.startDate.formatted(date: .numeric, time: .omitted)) - \(timesheet.endDate.formatted(date: .numeric, time: .omitted))"
    }

    var body: some View {
        
        Form {
            ForEach($viewModel.workdays) { $workday in
                Section {
                    WorkdayView(
                        workday: $workday,
                        isTaskFieldFocused: $isTaskFieldFocused,
                        onDeleteWorkday: {
                            withAnimation {
                                deleteWorkday(id: workday.id)
                            }
                        }
                    )
                }
            }

            Section {
                Button {
                    withAnimation {
                        viewModel.addWorkday()
                    }
                    resetURL()
                } label: {
                    Label("Add Workday", systemImage: "text.pad.header.badge.plus")
                        .buttonStyle(.borderless)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderless)
            }

            Section(header: Text("Total time: \(viewModel.totalDuration.asHourMinuteString)")) {
                VStack {
                    if let url = viewModel.exportURL {
                        ShareLink("Share PDF", item: url)
                    } else {
                        Button {
                            saveAndExport(timesheet: timesheet)
                        } label: {
                            Label("Create PDF", systemImage: "document.badge.arrow.up")
                        }
                        .disabled(viewModel.workdays.isEmpty || isSaving)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .alert("PDF created", isPresented: $isShowingExportAlert) {
            Button("OK") { }
        } message: {
            Text("You can now share the file. Timesheet saved.")
        }
        .alert("Unsaved Changes", isPresented: $isShowingUnsavedChangesAlert) {
            Button("Save", action: saveAndDismiss)
                .keyboardShortcut(.defaultAction)
            Button("Discard Changes", role: .destructive) { dismiss() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Do you want to save them before leaving?")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: attemptDismiss) {
                    Label("Back", systemImage: "chevron.backward")
                }
                .disabled(isSaving)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: saveAndDismiss)
                    .disabled(isSaving)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTaskFieldFocused = false
                }
            }
        }
    }

    private func attemptDismiss() {
        if viewModel.hasUnsavedChanges {
            isTaskFieldFocused = false
            isShowingUnsavedChangesAlert = true
        } else {
            dismiss()
        }
    }

    private func deleteWorkday(id: UUID) {
        viewModel.workdays.removeAll { $0.id == id }
        resetURL()
    }

    private func saveAndDismiss() {
        guard isSaving == false else { return }
        isSaving = true
        Task {
            do {
                let hydrated = try await viewModel.save()
                await MainActor.run {
                    onSave(hydrated)
                    dismiss()
                }
            } catch {
                print("Save failed: \(error.localizedDescription)")
            }
            await MainActor.run { isSaving = false }
        }
    }

    private func saveAndExport(timesheet: TimesheetWithWorkdays) {
        guard isSaving == false else { return }
        isSaving = true
        Task {
            do {
                let hydrated = try await viewModel.save()
                let url = viewModel.renderPDF(timesheet: timesheet, workdays: viewModel.workdays)
                await MainActor.run {
                    onSave(hydrated)
                    viewModel.exportURL = url
                    isShowingExportAlert = true
                }
            } catch {
                print("Export flow failed: \(error.localizedDescription)")
                await MainActor.run {
                    resetURL()
                    isShowingExportAlert = false
                }
            }
            await MainActor.run { isSaving = false }
        }
    }

    private func resetURL() {
        viewModel.exportURL = nil
    }
}

#Preview {
    NavigationStack {
        TimesheetDetailView(
            timesheet: TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: Workday.mockData()
            ),
            onSave: { _ in }
        )
    }
}
