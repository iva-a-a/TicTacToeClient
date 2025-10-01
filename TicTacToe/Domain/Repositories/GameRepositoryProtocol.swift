//
//  GameRepositoryProtocol.swift
//  TicTacToe

import Foundation

public protocol GameRepositoryProtocol {
    func create(game: GameDomain) async throws -> GameDomain
    func update(game: GameDomain) async throws -> GameDomain
    func get(by id: UUID) async throws -> GameDomain?
    func getAll() async throws -> [GameDomain]
    func delete(by id: UUID) async throws
}
