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
        case title
        case userId = "user_id"
        case totalHours = "total_hours"
        case workdays = "workday"
    }

    var id: UUID
    var title: String?
    var userId: UUID
    var totalHours: Double?
    var workdays: [Workday]?
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
