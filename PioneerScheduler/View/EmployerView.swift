//
//  EmployerView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct EmployerView: View {
    @ObservedObject var vm: EmployeeViewModel
    
    var body: some View {
        NavigationStack {
            List(vm.employees) { employee in
                VStack(alignment: .leading) {
                    Text(employee.name)
                        .font(.title)
                    Text("Hours this week: \(employee.totalHoursForWeek.formatted())")
                        .font(.headline)
                    Text("Tasks worked on this week:")
                        .font(.headline)
                    ForEach(employee.timesheetsForWeek) { timesheet in
                        Text(timesheet.title)
                    }
                }
            }
            .navigationTitle("Employees")
        }
    }
}

#Preview {
    EmployerView(vm: EmployeeViewModel.mock)
}
