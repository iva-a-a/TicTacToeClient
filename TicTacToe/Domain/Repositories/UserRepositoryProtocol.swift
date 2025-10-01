//
//  UserRepositoryProtocol.swift
//  TicTacToe

import Foundation

protocol UserRepositoryProtocol {
    func create(user: UserDomain) async throws
    func get(byLogin login: String) async throws -> UserDomain?
    func get(byId id: UUID) async throws -> UserDomain?
    func getAll() async throws -> [UserDomain]
    func update(user: UserDomain) async throws
    func delete(user: UserDomain) async throws
}
