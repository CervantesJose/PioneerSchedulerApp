//
//  Timesheet.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 6/24/25.
//

import Foundation

struct Timesheet: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String?
    var is_complete: Bool
    var user_id: UUID
    var created_at: Date
    var updated_at: Date
}
