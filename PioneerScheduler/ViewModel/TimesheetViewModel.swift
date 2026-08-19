import Supabase
import SwiftUI

/// Errors surfaced by `TimesheetViewModel` that don't originate from Supabase.
enum TimesheetError: LocalizedError {
    case noSignedInUser

    var errorDescription: String? {
        switch self {
        case .noSignedInUser:
            "You need to be signed in to load timesheets."
        }
    }
}

@MainActor
@Observable
final class TimesheetViewModel {

    enum LoadingState {
        case idle
        case loading
        case loaded
        case failed(Error)
    }

    var timesheets: [TimesheetWithWorkdays] = []

    var isCreatingNewItemSheetPresented = false
    var state: LoadingState = .idle

    init() { }

    func fetchTimesheets() async {
        state = .loading

        guard let userID = await getUserID() else {
            // Without a user there is nothing to scope the query to. Surface it
            // rather than leaving `state` on `.loading` and spinning forever.
            state = .failed(TimesheetError.noSignedInUser)
            return
        }

        do {
            let fetched: [TimesheetWithWorkdays] = try await supabase
                .from(SBConstants.timesheetsTable)
                .select(SBConstants.workdayColumn)
                .eq(SBConstants.uidColumn, value: userID)
                .order(SBConstants.endDateColumn, ascending: false)
                .execute()
                .value

            timesheets = fetched
            state = .loaded
        } catch {
            state = .failed(error)
        }
    }

    func addTimesheet(startDate: Date, endDate: Date, workdays: [Workday] = []) async {
        guard let userID = await getUserID() else { return }

        let newTimesheet = TimesheetRow(
            id: UUID(),
            userId: userID,
            startDate: startDate,
            endDate: endDate
        )

        do {
            let inserted: TimesheetRow = try await supabase
                .from(SBConstants.timesheetsTable)
                .insert(newTimesheet)
                .select(SBConstants.all)
                .single()
                .execute()
                .value

            // Stamp the new timesheet's id onto each draft workday, then persist
            // them. workday.timesheet_id is a foreign key, so the timesheet row
            // must exist (inserted above) before the workdays can reference it.
            //
            // `.select()` makes Postgres return the stored rows, so the hydrated
            // timesheet is assembled locally. This row was just created, so there
            // cannot be workdays we don't know about — no re-fetch is needed.
            var savedWorkdays: [Workday] = []

            if workdays.isEmpty == false {
                let workdaysToSave = workdays.map { workday -> Workday in
                    var workday = workday
                    workday.timesheetId = inserted.id
                    return workday
                }

                savedWorkdays = try await supabase
                    .from(SBConstants.workdayTable)
                    .insert(workdaysToSave)
                    .select(SBConstants.all)
                    .execute()
                    .value
            }

            timesheets.insert(TimesheetWithWorkdays(row: inserted, workday: savedWorkdays), at: 0)
            toggleIsCreatingNewItemSheetPresented()
        } catch {
            print("Error adding timesheet: \(error)")
        }
    }

    func deleteTimesheet(id: UUID) async {
        guard let index = timesheets.firstIndex(where: { $0.id == id }) else { return }

        // Remove optimistically so the row animates away immediately.
        let removed = timesheets.remove(at: index)

        do {
            try await supabase
                .from(SBConstants.timesheetsTable)
                .delete()
                .eq(SBConstants.idStringColumn, value: id)
                .execute()
        } catch {
            // The row is still on the server, so put it back instead of letting
            // the list quietly disagree with the backend until the next fetch.
            timesheets.insert(removed, at: min(index, timesheets.count))
            print("Error deleting timesheet: \(error)")
        }
    }

    func getUserID() async -> UUID? {
        do {
            return try await supabase.auth.user().id
        } catch {
            print("Error getting user id: \(error)")
            return nil
        }
    }

    func toggleIsCreatingNewItemSheetPresented() {
        self.isCreatingNewItemSheetPresented.toggle()
    }
}

extension TimesheetViewModel {

    static func preview() -> TimesheetViewModel {
        let vm = TimesheetViewModel()
        vm.timesheets = TimesheetWithWorkdays.mockData()
        vm.state = .loaded
        return vm
    }

    func apply(hydrated: TimesheetWithWorkdays) {
        if let index = timesheets.firstIndex(where: { $0.id == hydrated.id }) {
            timesheets[index] = hydrated
        } else {
            timesheets.insert(hydrated, at: 0)
        }
    }
}
