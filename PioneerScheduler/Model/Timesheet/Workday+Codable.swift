//
//  Workday+Codable.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/4/25.
//

import Foundation

extension Workday {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        task = try container.decodeIfPresent([String].self, forKey: .task)
        timeStart = try container.decodeIfPresent(Date.self, forKey: .timeStart)
        timeEnd = try container.decodeIfPresent(Date.self, forKey: .timeEnd)
        timeWorked = try container.decodeIfPresent(Double.self, forKey: .timeWorked)
        timesheetId = try container.decodeIfPresent(UUID.self, forKey: .timesheetId)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(task, forKey: .task)
        try container.encodeIfPresent(timeStart, forKey: .timeStart)
        try container.encodeIfPresent(timeEnd, forKey: .timeEnd)
        try container.encodeIfPresent(timeWorked, forKey: .timeWorked)
        try container.encodeIfPresent(timesheetId, forKey: .timesheetId)
    }
}
