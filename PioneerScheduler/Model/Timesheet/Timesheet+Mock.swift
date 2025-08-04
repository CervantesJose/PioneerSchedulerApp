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
                title: "Mock timesheet",
                userId: UUID(),
                totalHours: 8,
                workdays: Workday.mockData(),
            ),
            Timesheet(
                id: UUID(),
                title: "Mock timesheet 2",
                userId: UUID(),
                totalHours: 16,
                workdays: []
            ),
            Timesheet(
                id: UUID(),
                title: "Mock timesheet 3",
                userId: UUID(),
                totalHours: 48,
                workdays: []
            )
        ]
    }

    init(
        id: UUID,
        title: String,
        userId: UUID,
        totalHours: Double,
        workdays: [Workday]
    ) {
        self.id = id
        self.title = title
        self.userId = userId
        self.totalHours = totalHours
        self.workdays = workdays
    }
}
