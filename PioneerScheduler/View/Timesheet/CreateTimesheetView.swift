//
//  CreateTimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/9/25.
//

import SwiftUI

struct CreateTimesheetView: View {
    @EnvironmentObject var viewModel: TimesheetViewModel
    @State private var startDate: Date = .now
    @State private var endDate: Date = Date(timeIntervalSinceNow: 186000)
    @State private var title = ""
    @State private var description = ""

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {
                Section("Week of:") {
                    HStack {
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                    }
                }

                TextField("Title", text: $title)
                    .pioneerTextField()

                TextField("Description", text: $description)
                    .pioneerTextField()

                Spacer()

                Button {
                    Task {
                        await viewModel
                            .addTimesheet(
                                title: viewModel.newTimesheetTitle,
                                description: viewModel.workdays.first?.taskDescription,
                                workDates: [viewModel.newTimesheetDate]
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
