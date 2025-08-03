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
    @Published var newTimesheetDate: Date = .now

    @Published var isCreatingNewItemSheetPresented = false
    @Published var state: LoadingState = .idle

    @Published var entries: [TimesheetEntry] = []

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

    func addTimesheet(title: String, description: String?, workDates: [Date]?) async {
        if let userID = await getUserID() {
            let newTimesheet = Timesheet(
                id: UUID(),
                title: title,
                description: description,
                isComplete: false,
                userId: userID,
                createdAt: .now,
                workDates: workDates
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

    func updateTimesheet(id: UUID, title: String, description: String?, workDates: [Date]?) async {

        let workDateStrings = iso8601Strings(from: workDates ?? [])
        let postgresArrayString = "{" + workDateStrings.map { "\"\($0)\"" }.joined(separator: ",") + "}"

        do {
            try await supabase
                .from("timesheets")
                .update([
                    "title": title,
                    "description": description ?? "",
                    "work_dates": postgresArrayString
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

    func addEntry() {
        entries.append(TimesheetEntry())
    }

    func removeEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
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

    private func iso8601Strings(from dates: [Date]) -> [String] {
        let formatter = ISO8601DateFormatter()
        return dates.map { formatter.string(from: $0) }
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
