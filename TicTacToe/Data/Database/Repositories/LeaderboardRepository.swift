//
//  LeaderboardRepository.swift
//  TicTacToe

import Foundation
import CoreData

final class LeaderboardRepository: LeaderboardRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create(stats: PlayerStatsDomain) async throws {
        let context = self.context
        return try await context.perform {
            let _ = PlayerStatsMapper.toEntity(stats, context: context)
            try context.save()
        }
    }
    
    func update(stats: PlayerStatsDomain) async throws {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
            request.predicate = NSPredicate(format: "playerId == %@", stats.userId as CVarArg)
            guard let entity = try context.fetch(request).first else {
                return
            }
            entity.playerId = stats.userId
            entity.login = stats.login
            entity.winRatio = stats.winRatio
            try context.save()
        }
    }
    func get(by id: UUID) async throws -> PlayerStatsDomain? {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
            request.predicate = NSPredicate(format: "playerId == %@", id as CVarArg)
            guard let entity = try context.fetch(request).first else { return nil }
            return PlayerStatsMapper.toDomain(entity)
        }
    }
    func getAll() async throws -> [PlayerStatsDomain] {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
            let entities = try context.fetch(request)
            return entities.map { PlayerStatsMapper.toDomain($0) }
        }
    }
    func delete(by id: UUID) async throws {
        let context = self.context
        try await context.perform {
            let request: NSFetchRequest<PlayerStatsEntity> = PlayerStatsEntity.fetchRequest()
            request.predicate = NSPredicate(format: "playerId == %@", id as CVarArg)
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                try context.save()
            }
        }
    }
    
    func deleteAll() async throws {
        let context = self.context
        try await context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PlayerStatsEntity.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                let entities = try context.fetch(PlayerStatsEntity.fetchRequest()) as? [PlayerStatsEntity] ?? []
                for entity in entities {
                    context.delete(entity)
                }
                try context.save()
            }
        }
    }
}

