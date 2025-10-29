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
    private let tokenRepository: TokenRepositoryProtocol
    private let coordinator: AppCoordinator

    init(
        apiService: ApiServiceProtocol,
        currentUserService: CurrentUserServiceProtocol,
        userService: UserServiceProtocol,
        sessionService: SessionServiceProtocol,
        tokenRepository: TokenRepositoryProtocol,
        coordinator: AppCoordinator,
        errorHandler: ErrorHandlerProtocol
    ) {
        self.apiService = apiService
        self.currentUserService = currentUserService
        self.userService = userService
        self.sessionService = sessionService
        self.tokenRepository = tokenRepository
        self.coordinator = coordinator
        super.init(errorHandler: errorHandler)
    }

    func signIn() {
        guard validateInputs() else { return }

        performWithLoading {
            do {
                try await self.sessionService.resetSession()

                let userDomain = try await self.authenticateUser()
                try await self.ensureSessionConsistency(with: userDomain)
                try await self.persistUser(userDomain)
                try await self.setCurrentUser(userDomain)

            } catch {
                await self.handleError(error)
                try? await self.tokenRepository.clear()
                try? await self.currentUserService.clearCurrentUser()
            }
        }
    }

    private func authenticateUser() async throws -> UserDomain {
        let jwtDto = try await self.apiService.signIn(
            request: SignUpRequestDto(login: self.login, password: self.password)
        )
        let tokenModel = TokenMapper.toModel(jwtDto)
        try await self.tokenRepository.save(token: tokenModel)
        let userDto = try await self.apiService.getMe()
        return UserDomain(id: userDto.id, login: userDto.login, password: self.password)
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
