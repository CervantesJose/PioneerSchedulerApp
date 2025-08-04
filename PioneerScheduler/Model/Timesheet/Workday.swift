//
//  TimesheetEntry.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import Foundation

struct Workday: Codable, Identifiable, Hashable {

    let id: UUID
    var date: Date
    var task: [String]?
    var timeStart: Date
    var timeEnd: Date

    var timeWorked: Double
//    : TimeInterval {
//        return timeEnd.timeIntervalSince(timeStart)
//    }
//
//    var totalTimeFormatted: String {
//        let hours = Int(timeWorked) / 3600
//        let minutes = (Int(timeWorked) % 3600) / 60
//        return "\(hours)h \(minutes)m"
//    }

    enum CodingKeys: String, CodingKey {
        case id, date, task
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case timeWorked = "time_worked"
    }
}
