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
        List(vm.employees) { employee in
            VStack(alignment: .leading) {
                Text(employee.name)
                    .font(.title)
                Text("Hours this week: \(employee.totalHoursForWeek)")
                    .font(.headline)
                Text("Tasks worked on this week:")
                    .font(.headline)
                ForEach(employee.tasksForWeek) { task in
                    Text(task.name)
                }
            }
        }
    }
}

#Preview {
    EmployerView(vm: EmployeeViewModel.mock)
}
