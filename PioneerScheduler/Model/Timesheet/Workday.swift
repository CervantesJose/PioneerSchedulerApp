//
//  Workday.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import Foundation

struct Workday: Codable, Identifiable, Hashable {

    let id: UUID
    var date: Date
    var tasks: [String]
    var timeStart: Date
    var timeEnd: Date

    var duration: TimeInterval {
        max(0, timeEnd.timeIntervalSince(timeStart))
    }

    var timesheetId: UUID?

    enum CodingKeys: String, CodingKey {
        case id, date, task
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case timeWorked = "time_worked"
        case timesheetId = "timesheet_id"
    }
}
