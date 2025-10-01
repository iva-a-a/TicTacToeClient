//
//  NewGameView.swift
//  TicTacToe

import SwiftUI

struct NewGameView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: NewGameViewModel
    
    init(coordinator: AppCoordinator, viewModelFactory: ViewModelFactory) {
        self._coordinator = ObservedObject(initialValue: coordinator)
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeNewGameViewModel())
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
            .errorAlert(message: $viewModel.alertMessage)
        }
    }
}

private extension NewGameView {
    var titleView: some View {
        Text("New Game")
            .font(.largeTitle)
            .bold()
    }
}

private extension NewGameView {
    var gameOptions: some View {
        VStack(spacing: 16) {
            PrimaryButton(title: "Play vs Computer", color: .blue, isDisabled: viewModel.isLoading) {
                viewModel.createGame(withAI: true)
            }
            PrimaryButton(title: "Play vs Player", color: .green, isDisabled: viewModel.isLoading) {
                viewModel.createGame(withAI: false)
            }
        }
    }
}

private extension NewGameView {
    var loadingView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Creating game...")
                    .padding()
            }
        }
    }
}

private extension NewGameView {
    var portraitLayout: some View {
        VStack(spacing: 24) {
            titleView
            loadingView
            gameOptions
            Spacer()
        }
    }

    var landscapeLayout: some View {
        HStack(spacing: 32) {
            VStack {
                titleView
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 24) {
                loadingView
                gameOptions
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}
