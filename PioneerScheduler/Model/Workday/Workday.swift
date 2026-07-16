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

    var id: UUID
    var timesheetId: UUID
    var date: Date
    var tasks: [String]
    var timeStart: Date
    var timeEnd: Date

    var duration: TimeInterval { max(0, timeEnd.timeIntervalSince(timeStart)) }

    init(
        id: UUID = UUID(),
        timesheetId: UUID,
        date: Date = .now,
        tasks: [String] = [],
        timeStart: Date = (Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: .now) ?? .now),
        timeEnd: Date = (Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: .now) ?? .now)
    ) {
        self.id = id
        self.timesheetId = timesheetId
        self.date = date
        self.tasks = tasks
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
}
