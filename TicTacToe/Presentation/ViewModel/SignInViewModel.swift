//
//  LoginViewModel.swift
//  TicTacToe

import SwiftUI
import Foundation

@MainActor
final class SignInViewModel: BaseViewModel {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var isPasswordHidden: Bool = true
    @Published var currentUser: UserViewData?

    private let apiService: ApiServiceProtocol
    private let currentUserService: CurrentUserServiceProtocol
    private let userService: UserServiceProtocol
    private let sessionService: SessionServiceProtocol
    private let coordinator: AppCoordinator

    init(apiService: ApiServiceProtocol,
         currentUserService: CurrentUserServiceProtocol,
         userService: UserServiceProtocol,
         sessionService: SessionServiceProtocol,
         coordinator: AppCoordinator,
         errorHandler: ErrorHandlerProtocol) {
        
        self.apiService = apiService
        self.currentUserService = currentUserService
        self.userService = userService
        self.sessionService = sessionService
        self.coordinator = coordinator
        
        super.init(errorHandler: errorHandler)
    }

    func signIn() {
        guard validateInputs() else { return }

        performWithLoading {
            do {
                let finalUser = try await self.authenticateUser()
                try await self.ensureSessionConsistency(with: finalUser)
                try await self.persistUser(finalUser)
                try await self.setCurrentUser(finalUser)
            } catch {
                await self.handleError(error)
                try? await self.currentUserService.clearCurrentUser()
            }
        }
    }
    
    private func authenticateUser() async throws -> UserDomain {
        let tempUser = UserDomain(id: UUID(), login: self.login, password: self.password)
        try await self.currentUserService.setCurrentUser(user: tempUser)
        let userIdDto = try await apiService.signIn()
        return UserDomain(id: userIdDto.id, login: login, password: password)
    }
    
    private func ensureSessionConsistency(with newUser: UserDomain) async throws {
        if let existingUser = try await currentUserService.getCurrentUser(),
           existingUser.login != newUser.login {
            try await sessionService.resetSession()
        }
    }
    
    private func persistUser(_ user: UserDomain) async throws {
        if let _ = try await userService.getUser(byLogin: user.login) {
            try await userService.update(user: user)
        } else {
            try await userService.createUser(user: user)
        }
    }
    
    private func setCurrentUser(_ user: UserDomain) async throws {
        try await currentUserService.setCurrentUser(user: user)
        currentUser = UserViewMapper.toViewData(user)
    }

    private func validateInputs() -> Bool {
        return validateNotEmpty(login, fieldName: "login") &&
        validateNotEmpty(password, fieldName: "password")
    }
}
