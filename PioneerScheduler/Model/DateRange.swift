//
//  DateRange.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 7/10/25.
//

import Foundation

struct DateRange: Equatable {
    var start: Date
    var end: Date

    init(start: Date, end: Date) {
        self.start = min(start, end)
        self.end = max(start, end)
    }

    var days: [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        var current = calendar.startOfDay(for: start)
        var endDay = calendar.startOfDay(for: end)

        while current <= endDay {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }
}
