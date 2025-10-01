//
//  CurrentGameView.swift
//  TicTacToe

import SwiftUI

struct CurrentGameView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: CurrentGameViewModel
    
    init(gameId: UUID, coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self._coordinator = ObservedObject(initialValue: coordinator)
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeCurrentGameViewModel(gameId: gameId))
    }

    var body: some View {
        OrientationReader { isLandscape in
            Group {
                if isLandscape {
                    landscapeLayout
                } else {
                    portraitLayout
                }
            }
            .padding()
            .onAppear { viewModel.start() }
            .onDisappear { viewModel.stop() }
            .errorAlert(message: $viewModel.alertMessage)
        }
    }
}

private extension CurrentGameView {
    var portraitLayout: some View {
        VStack(spacing: 20) {
            if let game = viewModel.game {
                header(for: game)
                playersRow(for: game)
                Text(game.state.title)
                    .font(.title2)
                    .bold()
                boardView(game: game)
            } else {
                ProgressView("Loading game...")
            }
            Spacer()
        }
    }

    var landscapeLayout: some View {
        HStack(spacing: 32) {
            if let game = viewModel.game {
                VStack(spacing: 12) {
                    header(for: game)
                    playersRow(for: game)
                    Text(game.state.title)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)

                boardView(game: game)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView("Loading game...")
            }
        }
        .padding()
    }
}

private extension CurrentGameView {
    func header(for game: GameViewData) -> some View {
        Text("Game ID: \(game.id.uuidString)")
            .font(.caption)
            .foregroundColor(.gray)
    }
}

private extension CurrentGameView {
    func playersRow(for game: GameViewData) -> some View {
        HStack {
            ForEach(game.players) { player in
                VStack {
                    Text(displayName(for: player))
                        .font(.headline)
                    Text(player.tile.rawValue)
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    func displayName(for player: PlayerViewData) -> String {
        player.login.isEmpty ? "AI" : player.login
    }
}

private extension CurrentGameView {
    func boardView(game: GameViewData) -> some View {
        BoardView(grid: game.board.grid) { row, col in
            guard viewModel.canMakeMove(game: game) else { return }
            Task { await viewModel.makeMove(row: row, col: col) }
        }
    }
}
