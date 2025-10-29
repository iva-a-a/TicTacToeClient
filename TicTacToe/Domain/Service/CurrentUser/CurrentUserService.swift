//
//  CurrentUserService.swift
//  TicTacToe

import Foundation

final class CurrentUserService: CurrentUserServiceProtocol {

    private let currentUserRepository: CurrentUserRepositoryProtocol

    init(currentUserRepository: CurrentUserRepositoryProtocol) {
        self.currentUserRepository = currentUserRepository
    }

    func setCurrentUser(user: UserDomain) async throws {
        try await currentUserRepository.set(user: user)
    }

    func getCurrentUser() async throws -> UserDomain? {
        try await currentUserRepository.get()
    }

    func clearCurrentUser() async throws {
        try await currentUserRepository.clear()
    }
}
