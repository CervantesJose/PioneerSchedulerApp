//
//  EmployeeView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct EmployeeView: View {
    @ObservedObject var vm: EmployeeViewModel
    
    @State private var hoursWorked: String = ""
    @State private var taskName: String = ""
    @State private var tasks: [Task] = []
    var employeeId: UUID
    
    var body: some View {
        VStack {
            TextField("Hours Worked", text: $hoursWorked)
                .keyboardType(.decimalPad)
            TextField("Task Name", text: $taskName)
            
            Button("Add Task") {
                let newTask = Task(name: taskName, completed: false)
                tasks.append(newTask)
                taskName = ""
            }
            
            Button("Log Workday") {
                if let hours = Double(hoursWorked) {
                    vm.logWorkday(for: employeeId, hours: hours, tasks: tasks)
                    tasks.removeAll()
                    hoursWorked = ""
                }
            }
            
            List(tasks) { task in
                Text(task.name)
            }
        }
        .padding()
    }
}

#Preview {
    if let mockEmployee = EmployeeViewModel.mock.employees.first {
        EmployeeView(vm: EmployeeViewModel.mock, employeeId: mockEmployee.id)
    } else {
        Text("No employee found")
    }
}
