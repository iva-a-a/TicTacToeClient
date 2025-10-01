//
//  RootView.swift
//  TicTacToe

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {

        let currentUserService = ContainerProvider.shared.resolve(CurrentUserServiceProtocol.self)
        let gameService = ContainerProvider.shared.resolve(GameServiceProtocol.self)
        let userService = ContainerProvider.shared.resolve(UserServiceProtocol.self)

        let sessionService = SessionService(currentUserService: currentUserService,
                                            gameService: gameService,
                                            userService: userService,
                                            coordinator: coordinator)

        let apiStrategy = ApiErrorHandlingStrategy(sessionService: sessionService)
        let errorHandler = ErrorHandler(strategy: apiStrategy)
        
        let viewModelFactory = ViewModelFactory(container: .shared,
                                                coordinator: coordinator,
                                                errorHandler: errorHandler)

        return NavigationStack(path: $coordinator.path) {
            SignInView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                .navigationDestination(for: AppScreen.self) { screen in
                    switch screen {
                    case .signIn:
                        SignInView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                    case .signUp:
                        SignUpView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                    case .newGame:
                        NewGameView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                    case .currentGame(let id):
                        CurrentGameView(gameId: id, coordinator: coordinator, viewModelFactory: viewModelFactory)
                    case .games:
                        GamesContainerView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                    }
                }
        }
    }
}
