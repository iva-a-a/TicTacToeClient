//
//  SignUpViewModel.swift
//  TicTacToe

import SwiftUI
import Foundation

@MainActor
final class SignUpViewModel: BaseViewModel {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordHidden: Bool = true
    @Published var isConfirmPasswordHidden: Bool = true

    private let apiService: ApiServiceProtocol
    private let userService: UserServiceProtocol
    private let coordinator: AppCoordinator

    init(apiService: ApiServiceProtocol,
         userService: UserServiceProtocol,
         coordinator: AppCoordinator,
         errorHandler: ErrorHandlerProtocol) {
        
        self.apiService = apiService
        self.userService = userService
        self.coordinator = coordinator
        
        super.init(errorHandler: errorHandler)
    }
    
    func signUp() async -> Bool {
        guard validateInputs() else { return false }

        return await withCheckedContinuation { continuation in
            performWithLoading {
                Task {
                    do {
                        let dto = SignUpRequestDto(login: self.login, password: self.password)
                        let userIdDto = try await self.apiService.signUp(dto)
                        let newUser = UserMapper.toDomain(UserDto(id: userIdDto.id, login: dto.login),
                                                          password: dto.password)
                        try await self.userService.createUser(user: newUser)
                        continuation.resume(returning: true)
                    } catch {
                        await self.handleError(error)
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }

    private func validateInputs() -> Bool {
        
        guard validateNotEmpty(login, fieldName: "login") else { return false }
        guard login.count >= 3 else {
            alertMessage = "Login must be at least 3 characters"
            return false
        }
        guard validateNotEmpty(password, fieldName: "password") else { return false }
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            return false
        }
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            return false
        }
        return true
    }
}
