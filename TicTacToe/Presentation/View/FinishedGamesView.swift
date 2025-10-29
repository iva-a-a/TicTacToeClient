//
//  FinishedGamesView.swift
//  TicTacToe

import SwiftUI

struct FinishedGamesView: View {
    private let coordinator: AppCoordinator
    private let viewModelFactory: ViewModelFactory
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self.coordinator = coordinator
        self.viewModelFactory = viewModelFactory
    }
    
    var body: some View {
        GamesListView(
            coordinator: coordinator,
            viewModel: viewModelFactory.makeFinishedGamesViewModel(),
            emptyState: EmptyStateView(
                image: "trophy",
                title: "No Finished Games",
                subtitle: "You haven't completed any games yet.",
                buttonTitle: "Start Playing",
                buttonAction: { coordinator.navigate(to: .newGame) }
            ),
            gameAction: { vm, game in
                vm.watchGame(gameId: game.id)
            }
        )
    }
}


