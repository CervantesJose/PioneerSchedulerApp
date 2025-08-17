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
        userId = try container.decode(UUID.self, forKey: .userId)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        totalHours = try container.decodeIfPresent(Double.self, forKey: .totalHours)
        workdays = try container.decodeIfPresent([Workday].self, forKey: .workdays) ?? []
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encodeIfPresent(totalHours, forKey: .totalHours)
        try container.encode(workdays, forKey: .workdays)
    }
}
