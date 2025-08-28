//
//  TimesheetDetailView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/30/25.
//

import SwiftUI

struct TimesheetDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: DetailViewModel
    let onSave: (TimesheetWithWorkdays) -> Void
    let timesheet: TimesheetWithWorkdays

    @State private var exportURL: URL?

    init(timesheet: TimesheetWithWorkdays, onSave: @escaping (TimesheetWithWorkdays) -> Void) {
        self.timesheet = timesheet
        _viewModel = StateObject(wrappedValue: DetailViewModel(timesheet: timesheet))
        self.onSave = onSave
    }

    private var title: String {
        "\(timesheet.startDate.formatted(date: .numeric, time: .omitted)) - \(timesheet.endDate.formatted(date: .numeric, time: .omitted))"
    }

    var body: some View {
        
        Form {
            Section("Workdays") {
                ForEach($viewModel.workdays) { $workday in
                    WorkdayView(workday: $workday)
                }
                .onDelete { indexSet in
                    viewModel.workdays.remove(atOffsets: indexSet)
                    exportURL = nil
                }

                Button(action: {
                    viewModel.addWorkday()
                    exportURL = nil
                }) {
                    Label("Add workday", systemImage: "plus")
                }
            }
            
            Section(header: Text("Total time: \(viewModel.totalDuration.asHourMinuteString)")) {
                VStack {
                    if let url = exportURL {
                        ShareLink("Share PDF", item: url)
                    } else {
                        Button {
                            exportURL = viewModel.renderPDF(timesheet: timesheet, workdays: viewModel.workdays)
                        } label: {
                            Label("Render PDF", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                .disabled(viewModel.workdays.isEmpty)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        do {
                            let hydrated = try await viewModel.save()
                            onSave(hydrated)
                            dismiss()
                        } catch {
                            print("Save failed: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
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
        .environmentObject(TimesheetViewModel.preview())
    }
}
