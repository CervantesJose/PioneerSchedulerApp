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
        case createdAt = "created_at"
    }

    var id: UUID
    var title: String
    var description: String?
    var isComplete: Bool
    var userId: UUID
    var createdAt: Date
}

extension Timesheet {
    static func mockData() -> [Timesheet] {
        [
            Timesheet(id: UUID(),
                      title: "Mock timesheet",
                      description: "Test string",
                      isComplete: false,
                      userId: UUID(),
                      createdAt: Date()
                     ),
            Timesheet(id: UUID(),
                      title: "Mock timesheet 2",
                      description: "Test string 2",
                      isComplete: false,
                      userId: UUID(),
                      createdAt: Date()
                     ),
            Timesheet(id: UUID(),
                      title: "Mock timesheet 3",
                      description: "Test string 3",
                      isComplete: false,
                      userId: UUID(),
                      createdAt: Date()
                     )
        ]
    }
}
