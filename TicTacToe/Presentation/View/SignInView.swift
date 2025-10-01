//
//  SignInView.swift
//  TicTacToe

import SwiftUI

struct SignInView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: SignInViewModel
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory){
        self._coordinator = ObservedObject(initialValue: coordinator)
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeSignInViewModel())
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
            .onAppear { viewModel.currentUser = nil }
            .onChange(of: viewModel.currentUser) { _, newUser in
                if newUser != nil {
                    coordinator.navigate(to: .games)
                }
            }
        }
    }
}

private extension SignInView {
    var titleView: some View {
        Text("Authorization")
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

private extension SignInView {
    var inputFields: some View {
        VStack(spacing: 16) {
            TextField("Login", text: $viewModel.login)
                .formFieldStyle()
            
            formPasswordField(title: "Password",
                              text: $viewModel.password,
                              isHidden: $viewModel.isPasswordHidden)
        }
    }
}

private extension SignInView {
    var buttons: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: "Sign in", color: .blue, isDisabled: viewModel.isLoading) {
                viewModel.signIn()
            }
            PrimaryButton(title: "Sign up", color: .green) {
                coordinator.navigate(to: .signUp)
            }
        }
    }
}

private extension SignInView {
    var portraitLayout: some View {
        VStack(spacing: 24) {
            titleView
            inputFields
            loadingView
            buttons
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
                buttons
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}
