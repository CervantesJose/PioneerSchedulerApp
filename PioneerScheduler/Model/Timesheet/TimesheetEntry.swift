//
//  TimesheetEntry.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/15/25.
//

import Foundation

struct TimesheetEntry: Identifiable {
    var id: UUID = UUID()
    var date: Date = Date()
    var taskDescription: String = ""
    var timeStart: Date = Date()
    var timeEnd: Date = Date()

    var totalTime: TimeInterval {
        return timeEnd.timeIntervalSince(timeStart)
    }

    var totalTimeFormatted: String {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
