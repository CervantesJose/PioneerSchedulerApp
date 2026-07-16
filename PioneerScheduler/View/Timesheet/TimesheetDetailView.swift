//
//  TimesheetDetailView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/30/25.
//

import SwiftUI

struct TimesheetDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: DetailViewModel
    let onSave: (TimesheetWithWorkdays) -> Void
    let timesheet: TimesheetWithWorkdays

    @State private var isShowingExportAlert = false
    @State private var isSaving = false
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
            Section("Workdays") {
                ForEach($viewModel.workdays) { $workday in
                    WorkdayView(workday: $workday, isTaskFieldFocused: $isTaskFieldFocused)
                }
                .onDelete { indexSet in
                    viewModel.workdays.remove(atOffsets: indexSet)
                    resetURL()
                }

                Button(action: {
                    viewModel.addWorkday()
                    resetURL()
                }) {
                    Label("Add workday", systemImage: "plus")
                }
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
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("PDF created", isPresented: $isShowingExportAlert) {
            Button("OK") { }
        } message: {
            Text("You can now share the file. Timesheet saved.")
        }
        .toolbar {
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
