//
//  TimesheetViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Supabase
import SwiftUI

@MainActor
@Observable
class TimesheetViewModel {

    enum LoadingState {
        case idle
        case loading
        case loaded
        case failed(Error)
    }

    var timesheets: [Timesheet] = []

    var newTimesheetTitle = ""
    var newTimesheetDescription = ""

    var isCreatingNewItemSheetPresented = false
    var state: LoadingState = .idle

    init() { }

    func fetchTimesheets() async {
        state = .loading

        if let userID = await getUserID() {
            do {
                let timesheets: [Timesheet] = try await supabase
                    .from("timesheets")
                    .select()
                    .eq("user_id", value: userID)
                    .execute()
                    .value

                self.timesheets = timesheets
                state = .loaded
            } catch {
                state = .failed(error)
            }
        }
    }

    func addTimesheet(title: String, description: String?) async {
        if let userID = await getUserID() {
            let newTimesheet = Timesheet(
                id: UUID(),
                title: title,
                description: description,
                isComplete: false,
                userId: userID,
                workday: Date()
            )

            do {
                try await supabase
                    .from("timesheets")
                    .insert(newTimesheet)
                    .execute()

                toggleIsCreatingNewItemSheetPresented()

                await fetchTimesheets()
            } catch {
                print("Error adding timesheet: \(error)")
            }
        }

        newTimesheetTitle = ""
        newTimesheetDescription = ""
    }

    func markAsCompleted(id: UUID) async {
        do {
            try await supabase
                .from("timesheets")
                .update(["is_complete": true])
                .eq("id", value: id)
                .execute()

            await fetchTimesheets()
        } catch {
            print("Error marking timesheet as completed: \(error)")
        }
    }

    func markAsIncomplete(id: UUID) async {
        do {
            try await supabase
                .from("timesheets")
                .update(["is_complete": false])
                .eq("id", value: id)
                .execute()

            await fetchTimesheets()
        } catch {
            print("Error marking timesheet as incomplete: \(error)")
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
