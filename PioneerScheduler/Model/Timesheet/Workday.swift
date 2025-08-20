//
//  Workday.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import Foundation

struct Workday: Codable, Identifiable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id, date, tasks
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case timesheetId = "timesheet_id"
    }

    var id: UUID = UUID()
    var timesheetId: UUID? = nil
    var date: Date = .now
    var tasks: [String] = []
    var timeStart: Date = .now
    var timeEnd: Date = .now

    var duration: TimeInterval {
        max(0, timeEnd.timeIntervalSince(timeStart))
    }

    init() { }
    
}

extension TimeInterval {
    // "H:MM" (e.g., 7:30)
    var asHourMinuteString: String {
        let totalMinutes = Int((self / 60).rounded())
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return String(format: "%dh:%02dm", hours, minutes)
    }
}
