//
//  InProgressGamesView.swift
//  TicTacToe

import SwiftUI

struct InProgressGamesView: View {
    private let coordinator: AppCoordinator
    private let viewModelFactory: ViewModelFactory
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self.coordinator = coordinator
        self.viewModelFactory = viewModelFactory
    }
    
    var body: some View {
        GamesListView(
            coordinator: coordinator,
            viewModel: viewModelFactory.makeInProgressGamesViewModel(),
            emptyState: EmptyStateView(
                image: "person.3",
                title: "No Active Games",
                subtitle: "Join or create a game to get started!",
                buttonTitle: "Create Game",
                buttonAction: { coordinator.navigate(to: .newGame) }
            ),
            gameAction: { vm, game in
                vm.continueGame(gameId: game.id)
            }
        )
    }
}
