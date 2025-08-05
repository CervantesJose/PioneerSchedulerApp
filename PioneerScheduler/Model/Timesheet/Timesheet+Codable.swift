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
        userId = try container.decode(UUID.self, forKey: .userId)
        totalHours = try container.decodeIfPresent(Double.self, forKey: .totalHours)
        workdays = try container.decodeIfPresent([Workday].self, forKey: .workdays) ?? []
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(userId, forKey: .userId)
        try container.encodeIfPresent(totalHours, forKey: .totalHours)
        try container.encode(workdays, forKey: .workdays)
    }
}
