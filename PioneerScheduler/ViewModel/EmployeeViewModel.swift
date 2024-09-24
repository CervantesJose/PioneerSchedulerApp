//
//  EmployeeViewModel.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import Foundation

class EmployeeViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoggedIn: Bool = false
    @Published var isEmployer: Bool = false
    @Published var currentEmployee: Employee?
    
    // Default employer credentials which will be edited heavily
    let employerUsername = "pioneer"
    let employerPassword = "password"
    
    func login(username: String, password: String) -> Bool {
        if username == employerUsername && password == employerPassword {
            isEmployer = true
            isLoggedIn = true
            return true
        } else if let employee = employees.first(where: { $0.email == username }) {
            currentEmployee = employee
            isEmployer = false
            isLoggedIn = true
            return true
        } else {
            return false
        }
    }
    
    func createEmployeeAccount(name: String, email: String) {
        let newEmployee = Employee(name: name, email: email, workdays: [])
        employees.append(newEmployee)
        currentEmployee = newEmployee
        isEmployer = false
        isLoggedIn = true
    }
    
    func logWorkday(for employeeId: UUID, hours: Double, tasks: [Task], date: Date = Date()) {
        if let index = employees.firstIndex(where: { $0.id == employeeId }) {
            let newWorkday = Workday(date: date, hoursWorked: hours, tasks: tasks)
            employees[index].workdays.append(newWorkday)
        }
    }
    
    func addEmployee(name: String, email: String) {
        let newEmployee = Employee(name: name, email: email, workdays: [])
        employees.append(newEmployee)
    }
    
    func totalHoursForWeek(for employeeId: UUID) -> Double {
        guard let employee = employees.first(where: { $0.id == employeeId }) else { return 0 }
        return employee.totalHoursForWeek
    }
    
    func tasksForWeek(for employeeId: UUID) -> [Task] {
        guard let employee = employees.first(where: { $0.id == employeeId }) else { return [] }
        return employee.tasksForWeek
    }
}

extension EmployeeViewModel {
    static var mock: EmployeeViewModel {
        let viewModel = EmployeeViewModel()
        let tasks = [
            Task(name: "Design UI", completed: true),
            Task(name: "Fix bugs", completed: false),
            Task(name: "Write documentation", completed: true)
        ]
        
        let workday1 = Workday(date: Date(), hoursWorked: 8, tasks: tasks)
        let workday2 = Workday(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, hoursWorked: 6, tasks: tasks)
        
        let employee1 = Employee(name: "John Doe", email: "john@example.com", workdays: [workday1, workday2])
        let employee2 = Employee(name: "Jane Smith", email: "jane@example.com", workdays: [workday1])
        
        viewModel.employees = [employee1, employee2]
        return viewModel
    }
}
