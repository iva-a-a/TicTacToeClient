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
        registerErrorHandling()
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
        container.register(ApiServiceProtocol.self) { resolver in
            ApiService(client: resolver.resolve(NetworkClient.self)!)
        }.inObjectScope(.container)

        container.register(RequestInterceptor.self) { resolver in
            let tokenRepo = resolver.resolve(TokenRepositoryProtocol.self)!
            let apiServiceProvider: () -> ApiServiceProtocol = {
                resolver.resolve(ApiServiceProtocol.self)!
            }
            return AuthRequestInterceptor(
                tokenRepository: tokenRepo,
                apiServiceProvider: apiServiceProvider
            )
        }.inObjectScope(.container)

        container.register(NetworkClient.self) { resolver in
            let interceptor = resolver.resolve(RequestInterceptor.self)
            return NetworkClient(interceptor: interceptor)
        }.inObjectScope(.container)
    }

    private func registerRepositories() {
        container.register(CurrentUserRepositoryProtocol.self) { resolver in
            CurrentUserRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }.inObjectScope(.container)

        container.register(UserRepositoryProtocol.self) { resolver in
            UserRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }.inObjectScope(.container)

        container.register(GameRepositoryProtocol.self) { resolver in
            GameRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }.inObjectScope(.container)
        
        container.register(LeaderboardRepositoryProtocol.self) { resolver in
            LeaderboardRepository(context: resolver.resolve(NSManagedObjectContext.self, name: "bgContext")!)
        }.inObjectScope(.container)
        
        container.register(TokenRepositoryProtocol.self) { _ in
            TokenRepository.shared
        }.inObjectScope(.container)

    }

    private func registerServices() {
        container.register(CurrentUserServiceProtocol.self) { resolver in
            CurrentUserService(currentUserRepository: resolver.resolve(CurrentUserRepositoryProtocol.self)!)
        }.inObjectScope(.container)

        container.register(UserServiceProtocol.self) { resolver in
            UserService(userRepository: resolver.resolve(UserRepositoryProtocol.self)!)
        }.inObjectScope(.container)

        container.register(GameServiceProtocol.self) { resolver in
            GameService(gameRepository: resolver.resolve(GameRepositoryProtocol.self)!)
        }.inObjectScope(.container)

        container.register(LeaderboardServiceProtocol.self) { resolver in
            LeaderboardService(leaderboardRepository: resolver.resolve(LeaderboardRepositoryProtocol.self)!)
        }.inObjectScope(.container)

        container.register(SessionServiceProtocol.self) { resolver in
            SessionService(
                currentUserService: resolver.resolve(CurrentUserServiceProtocol.self)!,
                gameService: resolver.resolve(GameServiceProtocol.self)!,
                userService: resolver.resolve(UserServiceProtocol.self)!,
                leaderboardService: resolver.resolve(LeaderboardServiceProtocol.self)!,
                tokenRepository: resolver.resolve(TokenRepositoryProtocol.self)!
            )
        }.inObjectScope(.container)
    }
    
    private func registerErrorHandling() {
        container.register(ApiErrorHandlingStrategy.self) { resolver in
            ApiErrorHandlingStrategy(sessionService: resolver.resolve(SessionServiceProtocol.self)!)
        }.inObjectScope(.container)
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(type) else {
            fatalError("Dependency \(type) not registered")
        }
        return dependency
    }
}

