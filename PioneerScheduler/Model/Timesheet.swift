//
//  Timesheet.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Foundation

struct Timesheet: Identifiable, Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isComplete = "is_complete"
        case userId = "user_id"
        case workday
    }

    var id: UUID
    var title: String
    var description: String?
    var isComplete: Bool
    var userId: UUID
    var workday: Date
}
