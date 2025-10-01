//
//  UserService.swift
//  TicTacToe

import Foundation

final class UserService: UserServiceProtocol {

    private let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func createUser(user: UserDomain) async throws {
        if let _ = try await userRepository.get(byLogin: user.login) {
            throw DatabaseError.alreadyExists("User with login \(user.login)")
        }
        try await userRepository.create(user: user)
    }

    func getUser(byLogin login: String) async throws -> UserDomain? {
        return try await userRepository.get(byLogin: login)
    }

    func getUser(byId id: UUID) async throws -> UserDomain? {
        return try await userRepository.get(byId: id)
    }

    func getAllUsers() async throws -> [UserDomain] {
        return try await userRepository.getAll()
    }

    func deleteUser(user: UserDomain) async throws {
        guard try await userRepository.get(byId: user.id) != nil else {
            throw DatabaseError.userNotFound
        }
        try await userRepository.delete(user: user)
    }
    
    func update(user: UserDomain) async throws {
        guard try await userRepository.get(byLogin: user.login) != nil else {
            throw DatabaseError.userNotFound
        }
        try await userRepository.update(user: user)
    }
}
