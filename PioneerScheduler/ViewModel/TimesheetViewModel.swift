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

    @Published var timesheets: [Timesheet] = []

    @Published var newTimesheetTitle = ""
    @Published var newTimesheetDate: Date = .now

    @Published var isCreatingNewItemSheetPresented = false
    @Published var state: LoadingState = .idle

    @Published var workdays: [Workday] = []

    init() { }

    func fetchTimesheets() async {
        state = .loading

        if let userID = await getUserID() {
            do {
                let response = try await supabase
                    .from("timesheets")
                    .select("*, workday(*)")
                    .eq("user_id", value: userID)
                    .execute()

                let timesheets: [Timesheet] = try JSONDecoder().decode([Timesheet].self, from: response.data)
                self.timesheets = timesheets

                state = .loaded
            } catch {
                state = .failed(error)
            }
        }
    }

    func addTimesheet(title: String) async {
        if let userID = await getUserID() {
            let newTimesheet = Timesheet(
                id: UUID(),
                title: title,
                userId: userID
            )

            do {
                try await supabase
                    .from("timesheets")
                    .insert(newTimesheet)
                    .execute()

                for workday in workdays {
                    try await supabase
                        .from("workday")
                        .insert(workday)
                        .execute()
                }

                timesheets.insert(newTimesheet, at: 0)
                toggleIsCreatingNewItemSheetPresented()
            } catch {
                print("Error adding timesheet: \(error)")
            }
        }

        newTimesheetTitle = ""
        workdays.removeAll()
    }

    func updateTimesheet(id: UUID, title: String) async {
        do {
            try await supabase
                .from("timesheets")
                .update([
                    "title": title
                    ])
                .eq("id", value: id)
                .execute()

            if let index = timesheets.firstIndex(where: { $0.id == id }) {
                timesheets[index].title = title
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

    func addWorkday() {
        workdays.append(Workday())
    }

    func removeEntry(at offsets: IndexSet) {
        workdays.remove(atOffsets: offsets)
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
        vm.timesheets = Timesheet.mockData()
        vm.state = .loaded
        return vm
    }
}
