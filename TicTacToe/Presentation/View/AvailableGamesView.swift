//
//  AvailableGamesView.swift
//  TicTacToe

import SwiftUI

struct AvailableGamesView: View {
    private let coordinator: AppCoordinator
    private let viewModelFactory: ViewModelFactory
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self.coordinator = coordinator
        self.viewModelFactory = viewModelFactory
    }
    
    var body: some View {
        GamesListView(
            coordinator: coordinator,
            viewModel: viewModelFactory.makeAvailableGamesViewModel(),
            emptyState: EmptyStateView(
                image: "gamecontroller",
                title: "No Games Available",
                subtitle: "Be the first to create a game!",
                buttonTitle: "Create Game",
                buttonAction: { coordinator.navigate(to: .newGame) }
            ),
            gameAction: { vm, game in
                vm.joinGame(gameId: game.id)
            }
        )
    }
}
