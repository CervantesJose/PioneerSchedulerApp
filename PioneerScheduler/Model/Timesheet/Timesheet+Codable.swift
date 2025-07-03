//
//  Timesheet+Codable.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/3/25.
//

import Foundation

extension Timesheet {

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        userId = try container.decode(UUID.self, forKey: .userId)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        if let dateStrings = try? container.decode([String].self, forKey: .workDates) {
            let formatter = ISO8601DateFormatter()
            workDates = dateStrings.compactMap { formatter.date(from: $0) }
        } else {
            workDates = nil
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(userId, forKey: .userId)
        try container.encode(createdAt, forKey: .createdAt)

        if let workDates = workDates {
            let formatter = ISO8601DateFormatter()
            let dateStrings = workDates.map { formatter.string(from: $0) }
            try container.encode(dateStrings, forKey: .workDates)
        }
    }
}
