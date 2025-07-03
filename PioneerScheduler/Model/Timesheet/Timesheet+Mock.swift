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
            Timesheet(id: UUID(),
                      title: "Mock timesheet",
                      description: "Test string",
                      isComplete: false,
                      userId: UUID(),
                      createdAt: .now,
                      workDates: [Date(), Date(timeIntervalSinceNow: -186000)]
                     ),
            Timesheet(id: UUID(),
                      title: "Mock timesheet 2",
                      description: "Test string 2",
                      isComplete: false,
                      userId: UUID(),
                      createdAt: .now
                     ),
            Timesheet(id: UUID(),
                      title: "Mock timesheet 3",
                      description: "Test string 3",
                      isComplete: false,
                      userId: UUID(),
                      createdAt: .now
                     )
        ]
    }

    init(
            title: String,
            description: String?,
            isComplete: Bool = false,
            userId: UUID,
            createdAt: Date = .now,
            workDates: [Date]? = nil
        ) {
            self.id = UUID()
            self.title = title
            self.description = description
            self.isComplete = isComplete
            self.userId = userId
            self.createdAt = createdAt
            self.workDates = workDates
        }
}
