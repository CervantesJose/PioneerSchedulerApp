//
//  ContentView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = EmployeeViewModel()
    @State private var isEmployer = false
    
    var body: some View {
        VStack {
            if vm.isLoggedIn {
                if vm.isEmployer {
                    EmployerView(vm: vm)
                } else if let employee = vm.currentEmployee {
                    EmployeeView(vm: vm, employeeId: employee.id)
                }
            } else {
                LoginView(vm: vm)
            }
        }
    }
}

#Preview {
    ContentView()
}
