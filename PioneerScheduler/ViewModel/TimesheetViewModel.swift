import Supabase
import SwiftUI

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

    private let decoder = JSONDecoder.supabase

    init() { }

    func fetchTimesheets() async {
        state = .loading
        guard let userID = await getUserID() else { return }

        do {
            let response = try await supabase
                .from(SBConstants.timesheetsTable)
                .select(SBConstants.workdayColumn)
                .eq(SBConstants.uidColumn, value: userID)
                .order(SBConstants.endDateColumn, ascending: false)
                .execute()

            let timesheets: [TimesheetWithWorkdays] = try decoder.decode(
                [TimesheetWithWorkdays].self,
                from: response.data
            )

            self.timesheets = timesheets
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
            let response = try await supabase
                .from(SBConstants.timesheetsTable)
                .insert(newTimesheet)
                .select(SBConstants.all)
                .single()
                .execute()

            let inserted = try decoder.decode(TimesheetRow.self, from: response.data)

            // Stamp the new timesheet's id onto each draft workday, then persist
            // them. workday.timesheet_id is a foreign key, so the timesheet row
            // must exist (inserted above) before the workdays can reference it.
            let workdaysToSave = workdays.map { workday -> Workday in
                var workday = workday
                workday.timesheetId = inserted.id
                return workday
            }

            if workdaysToSave.isEmpty == false {
                try await supabase
                    .from(SBConstants.workdayTable)
                    .insert(workdaysToSave)
                    .execute()
            }

            let hydratedResponse = try await supabase
                .from(SBConstants.timesheetsTable)
                .select(SBConstants.workdayColumn)
                .eq(SBConstants.idStringColumn, value: inserted.id)
                .single()
                .execute()

            let hydrated = try decoder.decode(TimesheetWithWorkdays.self, from: hydratedResponse.data)
            timesheets.insert(hydrated, at: 0)
            toggleIsCreatingNewItemSheetPresented()
        } catch {
            print("Error adding timesheet: \(error)")
        }
    }

    func deleteTimesheet(id: UUID) async {
        if let index = timesheets.firstIndex(where: { $0.id == id }) {
            timesheets.remove(at: index)
        }

        do {
            try await supabase
                .from(SBConstants.timesheetsTable)
                .delete()
                .eq(SBConstants.idStringColumn, value: id)
                .execute()
        } catch {
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
