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
        case workdays
    }

    var id: UUID
    var title: String?
    var userId: UUID
    var totalHours: Double?
    var workdays: [Workday] = []
}
