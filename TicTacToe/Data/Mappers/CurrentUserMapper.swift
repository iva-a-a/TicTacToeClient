//
//  CurrentUserMapper.swift
//  TicTacToe

import Foundation
import CoreData

struct CurrentUserMapper {
    static func toDomain(_ entity: CurrentUserEntity) -> UserDomain {
        return UserDomain(
            id: entity.id ?? UUID(),
            login: entity.login ?? "",
            password: entity.password ?? ""
        )
    }

    static func toEntity(_ domain: UserDomain, context: NSManagedObjectContext) -> CurrentUserEntity {
        let entity = CurrentUserEntity(context: context)
        entity.id = domain.id
        entity.login = domain.login
        entity.password = domain.password
        return entity
    }
}
