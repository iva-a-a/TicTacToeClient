//
//  GameRepository.swift
//  TicTacToe

import Foundation
import CoreData

final class GameRepository: GameRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(game: GameDomain) async throws -> GameDomain {
        let context = self.context
        return try await context.perform {
            let entity = GameMapper.toEntity(game, context: context)
            try context.save()
            return GameMapper.toDomain(entity)
        }
    }
    
    func update(game: GameDomain) async throws -> GameDomain {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", game.id as CVarArg)
            
            guard let entity = try context.fetch(request).first else {
                return game
            }
            
            let (state, currentTurnPlayerId, winnerId, isDraw) = StateMapper.toEntity(game.state)
            let (playerXId, playerOId, playerXLogin, playerOLogin) = PlayersMapper.toEntity(game.players)
            
            entity.gridArray = game.board.grid.map { $0.map { $0.rawValue } }
            entity.state = state
            entity.current_turn_player_id = currentTurnPlayerId
            entity.winner_id = winnerId
            entity.is_draw = isDraw
            entity.playerX_id = playerXId
            entity.playerO_id = playerOId
            entity.playerX_login = playerXLogin
            entity.playerO_login = playerOLogin
            entity.with_AI = game.withAI
            
            try context.save()
            return GameMapper.toDomain(entity)
        }
    }

    func get(by id: UUID) async throws -> GameDomain? {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            guard let entity = try context.fetch(request).first else { return nil }
            return GameMapper.toDomain(entity)
        }
    }
    
    func getAll() async throws -> [GameDomain] {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
            let entities = try context.fetch(request)
            return entities.map { GameMapper.toDomain($0) }
        }
    }
    
    func delete(by id: UUID) async throws {
        let context = self.context
        try await context.perform {
            let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                try context.save()
            }
        }
    }
}
