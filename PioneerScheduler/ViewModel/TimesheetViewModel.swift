//
//  TimesheetViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Supabase
import SwiftUI

@MainActor
class TimesheetViewModel: ObservableObject {

    enum LoadingState {
        case idle
        case loading
        case loaded
        case failed(Error)
    }

    @Published var timesheets: [TimesheetWithWorkdays] = []

    @Published var isCreatingNewItemSheetPresented = false
    @Published var state: LoadingState = .idle

    private let decoder = JSONDecoder.supabase

    init() { }

    func fetchTimesheets() async {
        state = .loading
        guard let userID = await getUserID() else { return }

        do {
            let response = try await supabase
                .from("timesheets")
                .select("*, workday(*)")
                .eq("user_id", value: userID)
                .order("end_date", ascending: false)
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

    func addTimesheet(startDate: Date, endDate: Date) async {
        guard let userID = await getUserID() else { return }

        let newTimesheet = TimesheetRow(
            id: UUID(),
            userId: userID,
            startDate: startDate,
            endDate: endDate
        )

        do {
            let response = try await supabase
                .from("timesheets")
                .insert(newTimesheet)
                .select("*")
                .single()
                .execute()

            let inserted = try decoder.decode(TimesheetRow.self, from: response.data)
            let hydratedResponse = try await supabase
                .from("timesheets")
                .select("*, workday(*)")
                .eq("id", value: inserted.id)
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
                .from("timesheets")
                .delete()
                .eq("id", value: id)
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
