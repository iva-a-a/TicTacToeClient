//
//  UserMapper.swift
//  TicTacToe

import Foundation
import CoreData

struct UserMapper {
    static func toDomain(_ entity: UserEntity) -> UserDomain {
        return UserDomain(id: entity.id ?? UUID(),
                          login: entity.login ?? "",
                          password: entity.password ?? "")
    }

    static func toEntity(_ domain: UserDomain, context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)
        entity.id = domain.id
        entity.login = domain.login
        entity.password = domain.password
        return entity
    }
    
    static func toDomain(_ dto: UserDto, password: String = "") -> UserDomain {
        UserDomain(id: dto.id, login: dto.login, password: password)
    }
    
    static func toDto(_ domain: UserDomain) -> UserDto {
        UserDto(id: domain.id, login: domain.login)
    }
}

