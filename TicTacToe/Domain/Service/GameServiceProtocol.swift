//
//  GameServiceProtocol.swift
//  TicTacToe

import Foundation

protocol GameServiceProtocol {

    func createGame(game: GameDomain) async throws -> GameDomain
    func updateGame(game: GameDomain) async throws -> GameDomain
    
    func getGame(by id: UUID) async throws -> GameDomain
    func getAllGames() async throws -> [GameDomain]
    func getGames(forUserId userId: UUID) async throws -> [GameDomain]

    func deleteGame(by id: UUID) async throws
}
