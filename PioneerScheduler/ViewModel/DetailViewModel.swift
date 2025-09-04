//
//  DetailViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/21/25.
//

import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {

    @Published var workdays: [Workday]
    let timesheetId: UUID
    private let originalIds: Set<UUID> // tracks originals to detect deletions

    var totalDuration: TimeInterval { workdays.reduce(0) { $0 + $1.duration } }

    private let decoder = JSONDecoder.supabase

    init(timesheet: TimesheetWithWorkdays) {
        let id = timesheet.id
        let mapped: [Workday] = (timesheet.workday).map {
            var workday = $0
            workday.timesheetId = id
            return workday
        }

        self.timesheetId = id
        self.workdays = mapped
        self.originalIds = Set(mapped.map(\.id))
    }

    func addWorkday() {
        workdays.append(Workday(timesheetId: timesheetId))
    }

    func removeWorkday(at offsets: IndexSet) {
        workdays.remove(atOffsets: offsets)
    }

    func save() async throws -> TimesheetWithWorkdays {
        for index in workdays.indices { workdays[index].timesheetId = timesheetId }

        try await supabase
            .from(SBConstants.workdayTable)
            .upsert(workdays)
            .execute()

        let currentIds = Set(workdays.map(\.id))
        let deletedIds = Array(originalIds.subtracting(currentIds))

        if deletedIds.isEmpty == false {
            try await supabase
                .from(SBConstants.workdayTable)
                .delete()
                .in(SBConstants.idStringColumn, values: deletedIds)
                .execute()
        }

        let hydratedResponse = try await supabase
            .from(SBConstants.timesheetsTable)
            .select(SBConstants.workdayColumn)
            .eq(SBConstants.idStringColumn, value: timesheetId)
            .single()
            .execute()

        return try decoder.decode(TimesheetWithWorkdays.self, from: hydratedResponse.data)
    }

    @MainActor
    func renderPDF(timesheet: TimesheetWithWorkdays, workdays: [Workday]) -> URL? {
    
        let view = TimesheetPDFView(timesheet: timesheet, workdays: workdays)
        let renderer = ImageRenderer(content: view)
        let url = URL.documentsDirectory.appending(
            path: "timesheet.pdf"
        )

        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
}
