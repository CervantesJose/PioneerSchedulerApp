//
//  TimesheetViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Supabase
import SwiftUI

@Observable
class TimesheetViewModel {
    var timesheets: [Timesheet] = []

    var newTimesheetTitle = ""
    var newTimesheetDescription = ""

    var isCreatingNewItemSheetPresented = false

    init() { }

    func fetchTimesheets() async {
        do {
            let timesheets: [Timesheet] = try await supabase
                .from("timesheets")
                .select()
                .execute()
                .value

            self.timesheets = timesheets
        } catch {
            print("Error fetching timesheets: \(error)")
        }
    }

    func addTimesheet(title: String, description: String?) async {
        let newTimesheet = Timesheet(
            id: UUID(),
            title: title,
            description: description,
            is_complete: false,
            user_id: UUID(),
            created_at: Date(),
            updated_at: Date()
        )

        toggleIsCreatingNewItemSheetPresented()

        do {
            try await supabase
                .from("timesheets")
                .insert(newTimesheet)
                .execute()
        } catch {
            print("Error adding timesheet: \(error)")
        }
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
        do {
            try await supabase
                .from("timesheets")
                .delete()
                .eq("id", value: id)
                .execute()
            
            await fetchTimesheets()
        } catch {
            print("Error deleting timesheet: \(error)")
        }
    }

    func toggleIsCreatingNewItemSheetPresented() {
        self.isCreatingNewItemSheetPresented.toggle()
    }
}
