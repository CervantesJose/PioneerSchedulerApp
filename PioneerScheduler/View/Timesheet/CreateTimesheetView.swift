//
//  CreateTimesheetView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/9/25.
//

import SwiftUI

struct CreateTimesheetView: View {
    @EnvironmentObject var viewModel: TimesheetViewModel
    @State private var selectedRange: DateRange?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Title")
                        .sectionTitle()

                    TextField("Enter title", text: $viewModel.newTimesheetTitle)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .sectionTitle()

                    ZStack(alignment: .topLeading) {
                        if viewModel.newTimesheetDescription.isEmpty {
                            Text("Enter description...")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }

                        TextEditor(text: $viewModel.newTimesheetDescription)
                            .frame(minHeight: 100, maxHeight: 200)
                            .scrollContentBackground(.hidden)
                            .padding(4)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.secondarySystemBackground))
                    )
                }

                Text("Days worked this week")
                    .sectionTitle()

                if let range = selectedRange {
                    Text("From \(range.start.formatted(date: .long, time: .omitted)) to \(range.end.formatted(date: .long, time: .omitted))")
                } else {
                    Text("No range selected")
                }

                DateRangeSelectorView(container: DateRangeSelectorViewModelHolder(selectedRange: $selectedRange), month: .now)

                Spacer()

                Button {
                    Task {
                        await viewModel
                            .addTimesheet(
                                title: viewModel.newTimesheetTitle,
                                description: viewModel.newTimesheetDescription,
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
