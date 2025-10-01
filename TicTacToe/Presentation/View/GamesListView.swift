//
//  GamesListView.swift
//  TicTacToe

import SwiftUI

struct GamesListView<VM: GamesListViewModelProtocol>: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: VM
    
    private let emptyState: EmptyStateView
    private let gameAction: (VM, GameViewData) -> Void
    
    init(
        coordinator: AppCoordinator,
        viewModel: @autoclosure @escaping () -> VM,
        emptyState: EmptyStateView,
        gameAction: @escaping (VM, GameViewData) -> Void
    ) {
        self._coordinator = ObservedObject(initialValue: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel())
        self.emptyState = emptyState
        self.gameAction = gameAction
    }
    
    var body: some View {
        OrientationReader { isLandscape in
            LoadingOrEmptyView(
                isLoading: viewModel.isLoading,
                itemsCount: viewModel.games.count,
                emptyView: emptyState
            ) {
                gamesList(isLandscape: isLandscape)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.fetchGames() }
        .errorAlert(message: $viewModel.alertMessage)
    }
    
    private func gamesList(isLandscape: Bool) -> some View {
        ScrollView {
            if isLandscape {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.games) { game in
                        GameCardBuilder(game: game) {
                            gameAction(viewModel, game)
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.games) { game in
                        GameCardBuilder(game: game) {
                            gameAction(viewModel, game)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .refreshable { await viewModel.refreshGames() }
    }
}
