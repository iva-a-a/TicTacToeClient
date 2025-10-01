//
//  CurrentUserRepositoryProtocol.swift
//  TicTacToe

import Foundation

protocol CurrentUserRepositoryProtocol {
    func set(user: UserDomain) async throws
    func get() async throws -> UserDomain?
    func clear() async throws
}
