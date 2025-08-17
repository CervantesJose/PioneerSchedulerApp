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
