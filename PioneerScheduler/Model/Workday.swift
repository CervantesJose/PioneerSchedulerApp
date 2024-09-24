//
//  Workday.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var completed: Bool
}

struct Workday: Identifiable {
    let id = UUID()
    var date: Date
    var hoursWorked: Double
    var tasks: [Task]
}
