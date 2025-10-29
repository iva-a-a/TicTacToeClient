//
//  RootView.swift
//  TicTacToe

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {

        let container = ContainerProvider.shared
        let sessionService = container.resolve(SessionServiceProtocol.self)
        let apiStrategy = ApiErrorHandlingStrategy(sessionService: sessionService)
        let errorHandler = ErrorHandler(strategy: apiStrategy, coordinator: coordinator)
        let viewModelFactory = ViewModelFactory(container: container,
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
                    case .leaderboard:
                        LeaderboardView(coordinator: coordinator, viewModelFactory: viewModelFactory)
                    }
                }
        }
    }
}
