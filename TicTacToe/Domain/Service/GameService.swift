//
//  GameService.swift
//  TicTacToe

import Foundation

final class GameService: GameServiceProtocol {

    private let gameRepository: GameRepositoryProtocol

    init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }

    func createGame(game: GameDomain) async throws -> GameDomain {
        return try await gameRepository.create(game: game)
    }

    func updateGame(game: GameDomain) async throws -> GameDomain {
        guard let _ = try await gameRepository.get(by: game.id) else {
            throw DatabaseError.gameNotFound
        }
        return try await gameRepository.update(game: game)
    }

    func getGame(by id: UUID) async throws -> GameDomain {
        guard let game = try await gameRepository.get(by: id) else {
            throw DatabaseError.gameNotFound
        }
        return game
    }

    func getAllGames() async throws -> [GameDomain] {
        return try await gameRepository.getAll()
    }

    func deleteGame(by id: UUID) async throws {
        guard try await gameRepository.get(by: id) != nil else {
            throw DatabaseError.gameNotFound
        }
        try await gameRepository.delete(by: id)
    }

    func getGames(forUserId userId: UUID) async throws -> [GameDomain] {
        return try await getAllGames().filter { $0.players.contains { $0.id == userId } }
    }
}
