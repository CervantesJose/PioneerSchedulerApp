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
                    tasks: ["Spring creek", "US 550"],
                    timeStart: Date(timeInterval: -18600, since: .now),
                    timeEnd: .now
                   ),
            Workday(id: UUID(),
                    date: Date(),
                    tasks: ["Crested booty", "Tohellyouride"],
                    timeStart: Date(timeInterval: -18600, since: .now),
                    timeEnd: .now
                   ),
            Workday(id: UUID(),
                    date: Date(),
                    tasks: ["Ridgway", "Vibin' (Unpaid)"],
                    timeStart: Date(timeInterval: -18600, since: .now),
                    timeEnd: .now
                   )
        ]
    }

    static func mockWorkDay() -> Workday {
        Workday(id: UUID(),
                date: Date(),
                tasks: ["Ridgway", "Vibin' (Unpaid)"],
                timeStart: Date(timeInterval: -18600, since: .now),
                timeEnd: .now,
               )
    }

    init() {
        self.id = UUID()
        self.date = Date()
        self.tasks = []
        self.timeStart = Date()
        self.timeEnd = Date()
    }
}
