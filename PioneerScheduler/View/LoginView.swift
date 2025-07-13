//
//  LoginView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {

    @Bindable var viewModel: AuthViewModel

    var body: some View {

        NavigationStack {

            ZStack {

                BackgroundView()

                VStack(spacing: 16) {
                    // Email field
                    TextField("Email", text: $viewModel.userEmail)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(8)

                    // Password field
                    SecureField("Password", text: $viewModel.userPassword)
                        .textContentType(.password)
                        .padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(8)

                    // Login button
                    Button {
                        viewModel.handleSignInButtonTapped()
                    } label: {
                        Text("Login")
                            .pioneerButtonStyle()
                    }
                    //                    .disabled(viewModel.isLoading || !viewModel.isValid)
                    .alert(viewModel.alertTitle, isPresented: $viewModel.isShowingAlert, actions: {
                        Button("OK", role: .cancel) { }
                    }, message: {
                        Text(viewModel.alertMessage)
                    })

                    Button {
                        viewModel.handleRegisterButtonTapped()
                    } label: {
                        Text("Register with Email")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 44)

                    }

                    orSeparatorView()

                    SignInWithAppleButton { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        viewModel.handleWithAppleButtonTapped(result: result)
                    }
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 44)
                    .padding()
                }
                .navigationTitle("Pioneer Timesheets")
                .padding()
            }
        }
    }
}

private func orSeparatorView() -> some View {
        return HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.secondary)
            
            Text("OR")
                .foregroundStyle(.secondary)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
}

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(Gradient(colors:
                            [Color("backgroundColor"),
                             Color("secondaryBackgroundColor")
                            ]))
            .ignoresSafeArea()
    }
}
