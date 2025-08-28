//
//  CreateTimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/9/25.
//

import SwiftUI

struct CreateTimesheetView: View {
    @EnvironmentObject var viewModel: TimesheetViewModel
    @State private var startDate: Date = (Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.start ?? .now)
    @State private var endDate: Date = (
        Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.end.addingTimeInterval(-1) ?? .now
    )

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {
                Section("Week of:") {
                    HStack {
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                    }
                    .padding(.trailing, 32)
                }

                Button {
                    Task {
                        await viewModel
                            .addTimesheet(
                                startDate: startDate,
                                endDate: endDate
                            )
                    }
                } label: {
                    Text("Save Timesheet")
                        .font(.headline)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.capsule)
                .frame(maxWidth: .infinity)

                Spacer()
            }
        }
        .padding()
        .navigationTitle("Create timesheet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.toggleIsCreatingNewItemSheetPresented()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateTimesheetView()
            .environmentObject(TimesheetViewModel.preview())
    }
}
