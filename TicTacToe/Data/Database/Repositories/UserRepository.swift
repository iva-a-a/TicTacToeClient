//
//  UserRepository.swift
//  TicTacToe

import Foundation
import CoreData

final class UserRepository: UserRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create(user: UserDomain) async throws {
        let context = self.context
        try await context.perform {
            _ = UserMapper.toEntity(user, context: context)
            try context.save()
        }
    }

    func get(byLogin login: String) async throws -> UserDomain? {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "login == %@", login)
            request.fetchLimit = 1
            guard let entity = try context.fetch(request).first else { return nil }
            return UserMapper.toDomain(entity)
        }
    }

    func get(byId id: UUID) async throws -> UserDomain? {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            guard let entity = try context.fetch(request).first else { return nil }
            return UserMapper.toDomain(entity)
        }
    }

    func getAll() async throws -> [UserDomain] {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            let entities = try context.fetch(request)
            return entities.map(UserMapper.toDomain)
        }
    }

    func delete(user: UserDomain) async throws {
        let context = self.context
        try await context.perform {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "login == %@", user.login as CVarArg)
            guard let entity = try context.fetch(request).first else {
                throw DatabaseError.userNotFound
            }
            context.delete(entity)
            try context.save()
        }
    }
    
    func update(user: UserDomain) async throws {
        let context = self.context
        try await context.perform {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "login == %@", user.login as CVarArg)
            request.fetchLimit = 1

            guard let entity = try context.fetch(request).first else {
                throw DatabaseError.userNotFound
            }

            entity.id = user.id
            entity.password = user.password
            try context.save()
        }
    }
}

