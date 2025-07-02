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
    @State private var timesheets: [Timesheet] = []
    var employeeId: UUID
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Hours Worked", text: $hoursWorked)
                    .keyboardType(.decimalPad)
                TextField("Location of work", text: $locationOfWork)
                
                Button("Add Task/Work Day") {
                    let newTimesheet = Timesheet(
                        id: UUID(),
                        title: "",
                        isComplete: false,
                        userId: UUID(),
                        createdAt: Date()
                    )
                    timesheets.append(newTimesheet)
                    locationOfWork = ""
                }
                .padding()
                
                Spacer()
                
                if timesheets.count == 0 {
                    Text("Task/Work day(s) will appear here")
                } else {
                    List(timesheets) { timesheet in
                        Text(timesheet.title)
                    }
                }
                
                Spacer()
                Button("Log Week") {
//                    if let hours = Double(hoursWorked) {
//                        $vm.logWorkday(for: employeeId, hours: hours, timesheets: timesheets)
//                        timesheets.removeAll()
//                        hoursWorked = ""
//                    }
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
