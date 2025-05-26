//
//  PioneerSchedulerApp.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

@main
struct PioneerSchedulerApp: App {
    var body: some Scene {
        WindowGroup {
            EmployeeView(vm: EmployeeViewModel.mock, employeeId: EmployeeViewModel.mock.employees.first!.id)
        }
    }
}
