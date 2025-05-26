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
    @State private var locationOfWork: String = ""
    @State private var tasks: [Task] = []
    var employeeId: UUID
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Hours Worked", text: $hoursWorked)
                    .keyboardType(.decimalPad)
                TextField("Location of work", text: $locationOfWork)
                
                Button("Add Task/Work Day") {
                    let newTask = Task(name: locationOfWork, completed: false)
                    tasks.append(newTask)
                    locationOfWork = ""
                }
                .padding()
                
                Spacer()
                
                if tasks.count == 0 {
                    Text("Task/Work day(s) will appear here")
                } else {
                    List(tasks) { task in
                        Text(task.name)
                    }
                }
                
                Spacer()
                Button("Log Week") {
                    if let hours = Double(hoursWorked) {
                        vm.logWorkday(for: employeeId, hours: hours, tasks: tasks)
                        tasks.removeAll()
                        hoursWorked = ""
                    }
                }
            }
            .navigationTitle("Work Week")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

#Preview {
    if let mockEmployee = EmployeeViewModel.mock.employees.first {
        EmployeeView(vm: EmployeeViewModel.mock, employeeId: mockEmployee.id)
    } else {
        Text("No employee found")
    }
}
