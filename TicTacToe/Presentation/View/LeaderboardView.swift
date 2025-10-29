//
//  LeaderboardView.swift
//  TicTacToe

import SwiftUI

struct LeaderboardView: View {
    
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: LeaderboardViewModel

    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeLeaderboardViewModel())
    }

    var body: some View {
        LoadingOrEmptyView(
            isLoading: viewModel.isLoading,
            itemsCount: viewModel.players.count,
            emptyView: EmptyStateView(
                image: "person.3.sequence",
                title: "There are no players",
                subtitle: "The leaderboard is still empty",
                buttonTitle: "Refresh"
            ) {
                viewModel.loadTopPlayers()
            }
        ) {
            VStack(spacing: 0) {
                header
                Divider()
                    .padding(.horizontal, 16)
                content
                .refreshable {
                    viewModel.loadTopPlayers()
                }
            }
        }
        .navigationTitle("Leaderboard")
        .errorAlert(message: $viewModel.alertMessage)
        .onAppear {
            viewModel.loadTopPlayers()
        }
    }
}

private extension LeaderboardView {
    var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Text("#")
                    .font(.subheadline.bold())
                    .frame(width: 40, alignment: .leading)
                
                Text("Login")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Win %")
                    .font(.subheadline.bold())
                    .frame(width: 60, alignment: .trailing)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .foregroundColor(.secondary)
            .background(Color(.systemBackground))
        }
    }
    
    var content: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.players) { player in
                    PlayerStatsCardView(player: player)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 12)
        }
    }
}
