//
//  TimesheetViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Combine
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

    @Published var timesheets: [Timesheet] = []

    @Published var newTimesheetTitle = ""
    @Published var newTimesheetDescription = ""

    @Published var isCreatingNewItemSheetPresented = false
    @Published var state: LoadingState = .idle

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
                createdAt: Date()
            )

            do {
                try await supabase
                    .from("timesheets")
                    .insert(newTimesheet)
                    .execute()

                toggleIsCreatingNewItemSheetPresented()

                timesheets.insert(newTimesheet, at: 0)
            } catch {
                print("Error adding timesheet: \(error)")
            }
        }

        newTimesheetTitle = ""
        newTimesheetDescription = ""
    }

    func updateTimesheet(id: UUID, title: String, description: String?) async {
        do {
            try await supabase
                .from("timesheets")
                .update([
                    "title": title,
                    "description": description ?? ""
                    ])
                .eq("id", value: id)
                .execute()

            if let index = timesheets.firstIndex(where: { $0.id == id }) {
                timesheets[index].title = title
                timesheets[index].description = description ?? ""
            }
        } catch {
            print(error.localizedDescription)
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

    func markAsCompleted(id: UUID) async {
        do {
            try await supabase
                .from("timesheets")
                .update(["is_complete": true])
                .eq("id", value: id)
                .execute()

            if let index = timesheets.firstIndex(where: { $0.id == id }) {
                timesheets[index].isComplete = true
            }
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

            if let index = timesheets.firstIndex(where: { $0.id == id }) {
                timesheets[index].isComplete = false
            }
        } catch {
            print("Error marking timesheet as incomplete: \(error)")
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
