//
//  Workday.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import Foundation

struct Workday: Identifiable {
    let id = UUID()
    var date: Date
    var hoursWorked: Double
    var timesheets: [Timesheet]
}
