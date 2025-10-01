//
//  CurrentUserRepository.swift
//  TicTacToe

import Foundation
import CoreData

final class CurrentUserRepository: CurrentUserRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func set(user: UserDomain) async throws {
        let context = self.context
        try await context.perform {
            let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
            let all = try context.fetch(request)
            all.forEach { context.delete($0) }

            _ = CurrentUserMapper.toEntity(user, context: context)
            try context.save()
        }
    }

    func get() async throws -> UserDomain? {
        let context = self.context
        return try await context.perform {
            let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
            request.fetchLimit = 1
            guard let entity = try context.fetch(request).first else { return nil }
            return CurrentUserMapper.toDomain(entity)
        }
    }

    func clear() async throws {
        let context = self.context
        try await context.perform {
            let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
            let all = try context.fetch(request)
            all.forEach { context.delete($0) }
            try context.save()
        }
    }
}


