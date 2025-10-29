//
//  GameRepositoryProtocol.swift
//  TicTacToe

import Foundation

protocol GameRepositoryProtocol {
    func create(game: GameDomain) async throws
    func update(game: GameDomain) async throws
    func get(by id: UUID) async throws -> GameDomain?
    func getAll() async throws -> [GameDomain]
    func delete(by id: UUID) async throws
    func deleteAll() async throws
}
