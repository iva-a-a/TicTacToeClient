//
//  ContainerProvider.swift
//  TicTacToe

import Foundation
import Swinject
import Alamofire
import CoreData

final class ContainerProvider {
    static let shared = ContainerProvider()
    let container: Container
    
    private init() {
        container = Container()
        
        registerCoreData()
        registerNetwork()
        registerRepositories()
        registerServices()
    }
    
    private func registerCoreData() {
        container.register(CoreDataStack.self) { _ in
            CoreDataStack.shared
        }.inObjectScope(.container)

        container.register(NSManagedObjectContext.self, name: "viewContext") { resolver in
            resolver.resolve(CoreDataStack.self)!.viewContext
        }

        container.register(NSManagedObjectContext.self, name: "bgContext") { resolver in
            resolver.resolve(CoreDataStack.self)!.bg()
        }
    }
    
    private func registerNetwork() {
        container.register(NetworkClient.self) { _ in
            NetworkClient.shared
        }.inObjectScope(.container)

        container.register(ApiServiceProtocol.self) { resolver in
            ApiService(client: resolver.resolve(NetworkClient.self)!)
        }.inObjectScope(.container)
    }
    
    private func registerRepositories() {
        container.register(CurrentUserRepositoryProtocol.self) { resolver in
            CurrentUserRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }

        container.register(UserRepositoryProtocol.self) { resolver in
            UserRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }

        container.register(GameRepositoryProtocol.self) { resolver in
            GameRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }
    }
    
    private func registerServices() {
        container.register(CurrentUserServiceProtocol.self) { resolver in
            CurrentUserService(currentUserRepository: resolver.resolve(CurrentUserRepositoryProtocol.self)!)
        }

        container.register(UserServiceProtocol.self) { resolver in
            UserService(userRepository: resolver.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(GameServiceProtocol.self) { resolver in
            GameService(gameRepository: resolver.resolve(GameRepositoryProtocol.self)!)
        }
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(type) else {
            fatalError("Dependency \(type) not registered")
        }
        return dependency
    }
}
