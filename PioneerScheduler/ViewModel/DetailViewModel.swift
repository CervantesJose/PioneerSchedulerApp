import SwiftUI

@MainActor
@Observable
final class DetailViewModel {

    var workdays: [Workday]
    let timesheetId: UUID
    private let row: TimesheetRow // the timesheet's own columns, unchanged by this screen
    private var originalIds: Set<UUID> // tracks originals to detect deletions
    private var savedWorkdays: [Workday] // last-saved snapshot to detect edits

    var totalDuration: TimeInterval { workdays.reduce(0) { $0 + $1.duration } }
    var exportURL: URL?

    var hasUnsavedChanges: Bool { workdays != savedWorkdays }

    init(timesheet: TimesheetWithWorkdays) {
        let id = timesheet.id
        let mapped: [Workday] = (timesheet.workday).map {
            var workday = $0
            workday.timesheetId = id
            return workday
        }

        self.timesheetId = id
        self.row = timesheet.row
        self.workdays = mapped
        self.originalIds = Set(mapped.map(\.id))
        self.savedWorkdays = mapped
    }

    func addWorkday() {
        workdays.append(Workday(timesheetId: timesheetId))
    }

    func removeWorkday(at offsets: IndexSet) {
        workdays.remove(atOffsets: offsets)
    }

    /// Reconciles the locally edited `workdays` with the backend and returns the
    /// hydrated timesheet.
    ///
    /// Editing is optimistic and local-first, so this is where the drafts become
    /// rows: changed workdays are upserted, workdays that disappeared since load
    /// are deleted, and the timesheet is re-read in its nested form so the list
    /// screen gets authoritative state.
    func save() async throws -> TimesheetWithWorkdays {
        for index in workdays.indices { workdays[index].timesheetId = timesheetId }

        let currentIds = Set(workdays.map(\.id))
        let deletedIds = Array(originalIds.subtracting(currentIds))

        // Only send rows that actually differ from the last-saved snapshot.
        // Tapping Save (or Create PDF) without editing anything then costs zero
        // requests instead of a full write-and-refetch cycle.
        let unchanged = Set(savedWorkdays)
        let changedWorkdays = workdays.filter { unchanged.contains($0) == false }

        guard changedWorkdays.isEmpty == false || deletedIds.isEmpty == false else {
            return TimesheetWithWorkdays(row: row, workday: workdays)
        }

        if changedWorkdays.isEmpty == false {
            try await supabase
                .from(SBConstants.workdayTable)
                .upsert(changedWorkdays)
                .execute()
        }

        if deletedIds.isEmpty == false {
            try await supabase
                .from(SBConstants.workdayTable)
                .delete()
                .in(SBConstants.idStringColumn, values: deletedIds)
                .execute()
        }

        let hydrated: TimesheetWithWorkdays = try await supabase
            .from(SBConstants.timesheetsTable)
            .select(SBConstants.workdayColumn)
            .eq(SBConstants.idStringColumn, value: timesheetId)
            .single()
            .execute()
            .value

        // Refresh the baselines so hasUnsavedChanges reflects the just-saved state.
        originalIds = currentIds
        savedWorkdays = workdays

        return hydrated
    }

    /// Renders the timesheet to a PDF on disk and returns its location, or `nil`
    /// if the render failed.
    ///
    /// The file goes in the caches directory, not Documents: it is a derived
    /// artifact that should not be swept into the user's iCloud backup, and the
    /// system is free to reclaim it. Each timesheet gets its own subdirectory so
    /// two weeks that format to the same name can't overwrite each other while
    /// the shared filename stays human-readable.
    func renderPDF(timesheet: TimesheetWithWorkdays, workdays: [Workday]) -> URL? {

        let view = TimesheetPDFView(timesheet: timesheet, workdays: workdays)
        let renderer = ImageRenderer(content: view)

        let name = "timesheet_\(Self.fileNameDateFormatter.string(from: timesheet.startDate))"
            + "_\(Self.fileNameDateFormatter.string(from: timesheet.endDate)).pdf"
        let directory = URL.cachesDirectory
            .appending(path: "Exports", directoryHint: .isDirectory)
            .appending(path: timesheet.id.uuidString, directoryHint: .isDirectory)
        let url = directory.appending(path: name)

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            print("Could not create export directory: \(error)")
            return nil
        }

        var didRender = false

        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: size)
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
            didRender = true
        }

        // Previously this returned `url` unconditionally, which handed ShareLink a
        // path to a missing or stale file whenever the context failed to open.
        return didRender ? url : nil
    }

    private static let fileNameDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
