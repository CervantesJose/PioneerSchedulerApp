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
            Workday(id: UUID(),
                    date: Date(),
                    task: ["Spring creek", "US 550"],
                    timeStart: Date(timeInterval: -18600, since: .now),
                    timeEnd: .now,
                    timeWorked: 6
                   ),
            Workday(id: UUID(),
                    date: Date(),
                    task: ["Crested booty", "Tohellyouride"],
                    timeStart: Date(timeInterval: -18600, since: .now),
                    timeEnd: .now,
                    timeWorked: 10
                   ),
            Workday(id: UUID(),
                    date: Date(),
                    task: ["Ridgway", "Vibin' (Unpaid)"],
                    timeStart: Date(timeInterval: -18600, since: .now),
                    timeEnd: .now,
                    timeWorked: 8
                   )
        ]
    }

    static func mockWorkDay() -> Workday {
        Workday(id: UUID(),
                date: Date(),
                task: ["Ridgway", "Vibin' (Unpaid)"],
                timeStart: Date(timeInterval: -18600, since: .now),
                timeEnd: .now,
                timeWorked: 8
               )
    }

    init() {
        self.id = UUID()
        self.date = Date()
        self.task = []
        self.timeStart = Date()
        self.timeEnd = Date()
        self.timeWorked = 0
    }
}
