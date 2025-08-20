//
//  Timesheet+Mock.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/3/25.
//

import Foundation

extension TimesheetWithWorkdays {
    static func mockData() -> [TimesheetWithWorkdays] {
        [
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: Workday.mockData(),
            ),
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: []
            ),
            TimesheetWithWorkdays(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workday: []
            )
        ]
    }

    init(
        id: UUID,
        title: String,
        userId: UUID,
        startDate: Date,
        endDate: Date,
        workday: [Workday]
    ) {
        self.id = id
        self.userId = userId
        self.startDate = startDate
        self.endDate = endDate
        self.workday = workday
    }
}
