//
//  LoginView.swift
//  PioneerScheduler
//
//  Created by Jose Cervantes on 9/24/24.
//

import SwiftUI

struct LoginView: View {

    private enum Constants {
        static let buttonPadding: CGFloat = 8
    }

    @Bindable var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.userEmail)
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(Constants.buttonPadding)

                SecureField("Password", text: $viewModel.userPassword)
                    .textContentType(.password)
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(Constants.buttonPadding)

                Button {
                    viewModel.handleSignInButtonTapped()
                } label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.blue)
                        .cornerRadius(Constants.buttonPadding)
                        .padding(.top)
                }
                //                    .disabled(viewModel.isLoading || !viewModel.isValid)
                .alert("Login Failed", isPresented: $viewModel.isShowingAlert, actions: {
                    Button("OK", role: .cancel) { }
                }, message: {
                    Text(viewModel.alertMessage)
                })
            }
            .navigationTitle("Login")
            .padding()
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(appState: AppState()))
}
