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
                            exportURL = renderPDF(timesheet: timesheet, workdays: viewModel.workdays)
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

    @MainActor
    func renderPDF(timesheet: TimesheetWithWorkdays, workdays: [Workday]) -> URL? {
        // 1: Render view
        let view = TimesheetPDFView(timesheet: timesheet, workdays: workdays)
        let renderer = ImageRenderer(content: view)

        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(
            path: "timesheet-\(timesheet.startDate.formatted(date: .numeric, time: .omitted))/\(timesheet.endDate.formatted(date: .numeric, time: .omitted)).pdf"
        )

        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }

            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)

            // 7: Render the SwiftUI view data onto the page
            context(pdf)

            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
}

struct TimesheetPDFView: View {
    let timesheet: TimesheetWithWorkdays
    let workdays: [Workday]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(
                "\(timesheet.startDate.formatted(date: .numeric, time: .omitted)) - \(timesheet.endDate.formatted(date: .numeric, time: .omitted))"
            )
                .font(.title)
                .bold()

            Divider()

            ForEach(workdays) { workday in
                VStack(alignment: .leading, spacing: 4) {
                    Text(workday.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)

                    if workday.tasks.isEmpty == false {
                        Text(workday.tasks.joined(separator: "\n"))
                            .font(.subheadline)
                    }

                    Text("Time worked: \(workday.duration.asHourMinuteString)")
                        .font(.subheadline)
                        .italic()
                }
                .padding(.vertical, 4)
            }

            Divider()

            Text("Total hours: \(workdays.reduce(0) { $0 + $1.duration }.asHourMinuteString)")
                .font(.headline)
        }
        .padding()
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
