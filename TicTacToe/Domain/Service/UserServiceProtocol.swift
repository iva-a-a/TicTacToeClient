//
//  UserServiceProtocol.swift
//  TicTacToe

import Foundation

protocol UserServiceProtocol {
    func createUser(user: UserDomain) async throws
    func getUser(byLogin login: String) async throws -> UserDomain?
    func getUser(byId id: UUID) async throws -> UserDomain?
    func getAllUsers() async throws -> [UserDomain]
    func update(user: UserDomain) async throws
    func deleteUser(user: UserDomain) async throws
}
