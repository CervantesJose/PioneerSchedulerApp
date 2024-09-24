//
//  Employee.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import Foundation

struct Employee: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var workdays: [Workday]
    
    var totalHoursForWeek: Double {
        let calendar = Calendar.current
        let week = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        
        return workdays.filter {
            calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: $0.date) == week
        }.reduce(0) { $0 + $1.hoursWorked }
    }
    
    var tasksForWeek: [Task] {
        let calendar = Calendar.current
        let week = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        
        return workdays.filter {
            calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: $0.date) == week
        }.flatMap { $0.tasks }
    }
}
