//
//  Workday+Mock.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 8/4/25.
//

import Foundation

extension Workday {
    static func mockData() -> [Workday] {
        [
            Workday(timesheetId: UUID())
        ]
    }

    static func mockWorkDay() -> Workday {
        Workday(timesheetId: UUID())
    }
}
