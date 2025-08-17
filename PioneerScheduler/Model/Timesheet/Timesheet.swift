//
//  Timesheet.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Foundation

struct Timesheet: Identifiable, Codable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalHours = "total_hours"
        case workdays = "workday"
    }

    var id: UUID
    var userId: UUID
    var startDate: Date
    var endDate: Date
    var totalHours: Double?
    var workdays: [Workday] = []

    init(id: UUID, userId: UUID, startDate: Date, endDate: Date, totalHours: Double? = nil, workdays: [Workday] = []) {
        self.id = id
        self.userId = userId
        self.startDate = startDate
        self.endDate = endDate
        self.totalHours = totalHours
        self.workdays = workdays
    }
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
