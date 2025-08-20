//
//  TimesheetRow.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/20/25.
//

import Foundation

struct TimesheetRow: Codable, Identifiable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalHours = "total_hours"
    }

    var id: UUID
    var userId: UUID
    var startDate: Date
    var endDate: Date
    var totalHours: Double?
}
