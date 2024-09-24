//
//  LoginView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: EmployeeViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var showCreateEmployee: Bool = false
    @State private var employeeName: String = ""
    @State private var employeeEmail: String = ""
    
    var body: some View {
        VStack {
            if showCreateEmployee {
                Text("Create employee account")
                TextField("Employee Name", text: $employeeName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Employee email", text: $employeeEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Create account") {
                    vm.createEmployeeAccount(name: employeeName, email: employeeEmail)
                }
                .padding()
            } else {
                Text("Login")
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Login") {
                    if !vm.login(username: username, password: password) {
                        showError = true
                    }
                }
                .padding()
                
                if showError {
                    Text("Invalid username or password")
                        .foregroundStyle(.red)
                }
                
                Button("Create employee account") {
                    showCreateEmployee = true
                }
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(vm: EmployeeViewModel.mock)
}
