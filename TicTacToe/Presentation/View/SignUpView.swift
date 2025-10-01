//
//  SignUpView.swift
//  TicTacToe

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: SignUpViewModel
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self._coordinator = ObservedObject(initialValue: coordinator)
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeSignUpViewModel())
    }

    var body: some View {
        OrientationReader { isLandscape in
            Group {
                if isLandscape {
                    landscapeLayout
                } else {
                    portraitLayout
                }
            }
            .padding()
            .errorAlert(message: $viewModel.alertMessage)
        }
    }
}

private extension SignUpView {
    var titleView: some View {
        Text("Registration")
            .font(.largeTitle)
            .bold()
    }

    var loadingView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
    }
}

private extension SignUpView {
    var inputFields: some View {
        VStack(spacing: 16) {
            formTextField("Login", text: $viewModel.login)
            formPasswordField(title: "Password", text: $viewModel.password, isHidden: $viewModel.isPasswordHidden)
            formPasswordField(title: "Confirm Password",
                              text: $viewModel.confirmPassword,
                              isHidden: $viewModel.isConfirmPasswordHidden)
        }
    }
}

private extension SignUpView {
    var signUpButton: some View {
        PrimaryButton(title: "Sign up", color: .green, isDisabled: viewModel.isLoading) {
            Task {
                let success = await viewModel.signUp()
                if success {
                    coordinator.navigate(to: .signIn)
                }
            }
        }
    }
}

private extension SignUpView {
    var portraitLayout: some View {
        VStack(spacing: 24) {
            titleView
            inputFields
            loadingView
            signUpButton
            Spacer()
        }
    }

    var landscapeLayout: some View {
        HStack(spacing: 32) {
            VStack {
                titleView
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 24) {
                inputFields
                loadingView
                signUpButton
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}
