//
//  PlayerStatsMapper.swift
//  TicTacToe

import Foundation
import CoreData

struct PlayerStatsMapper {
    static func toDomain(_ entity: PlayerStatsEntity) -> PlayerStatsDomain {
        return PlayerStatsDomain(userId: entity.playerId ?? UUID(),
                                 login: entity.login ?? "",
                                 winRatio: entity.winRatio)
    }

    static func toEntity(_ domain: PlayerStatsDomain, context: NSManagedObjectContext) -> PlayerStatsEntity {
        let entity = PlayerStatsEntity(context: context)
        entity.playerId = domain.userId
        entity.login = domain.login
        entity.winRatio = domain.winRatio
        return entity
    }
}

