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
        tasks = try container.decodeIfPresent([String].self, forKey: .tasks) ?? []
        timeStart = try container.decode(Date.self, forKey: .timeStart)
        timeEnd = try container.decode(Date.self, forKey: .timeEnd)
        timesheetId = try container.decode(UUID.self, forKey: .timesheetId)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(timeStart, forKey: .timeStart)
        try container.encode(timeEnd, forKey: .timeEnd)
        try container.encode(timesheetId, forKey: .timesheetId)
    }
}
