//
//  Timesheet+Mock.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/3/25.
//

import Foundation

extension Timesheet {
    static func mockData() -> [Timesheet] {
        [
            Timesheet(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workdays: Workday.mockData(),
            ),
            Timesheet(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workdays: []
            ),
            Timesheet(
                id: UUID(),
                userId: UUID(),
                startDate: .now,
                endDate: .now,
                workdays: []
            )
        ]
    }

    init(
        id: UUID,
        title: String,
        userId: UUID,
        startDate: Date,
        endDate: Date,
        workdays: [Workday]
    ) {
        self.id = id
        self.userId = userId
        self.startDate = startDate
        self.endDate = endDate
        self.workdays = workdays
    }
}
