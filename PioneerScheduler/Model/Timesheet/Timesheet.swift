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
        case description
        case isComplete = "is_complete"
        case userId = "user_id"
        case createdAt = "created_at"
        case workDates = "work_dates"
    }

    var id: UUID
    var title: String
    var description: String?
    var isComplete: Bool
    var userId: UUID
    var createdAt: Date
    var workDates: [Date]?
}
