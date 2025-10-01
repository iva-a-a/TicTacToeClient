//
//  InProgressGamesViewModel.swift
//  TicTacToe

import SwiftUI
import Foundation

@MainActor
final class InProgressGamesViewModel: BaseViewModel, GamesFetchable {
    @Published var games: [GameViewData] = []

    private let coordinator: AppCoordinator
    let apiService: ApiServiceProtocol
    let currentUserService: CurrentUserServiceProtocol
    private let gameService: GameServiceProtocol

    init(coordinator: AppCoordinator,
         apiService: ApiServiceProtocol,
         currentUserService: CurrentUserServiceProtocol,
         gameService: GameServiceProtocol,
         errorHandler: ErrorHandlerProtocol) {
        
        self.coordinator = coordinator
        self.apiService = apiService
        self.currentUserService = currentUserService
        self.gameService = gameService
        
        super.init(errorHandler: errorHandler)
    }

    func fetchUnfinishedGames() {
        performWithLoading {
            await self.fetchGamesFromAPI {
                try await self.apiService.getInProgressGames()
            }
        }
    }

    func refreshGames() async {
        await fetchGamesFromAPI {
            try await self.apiService.getInProgressGames()
        }
    }

    func continueGame(gameId: UUID) {
        coordinator.navigate(to: .currentGame(id: gameId))
    }
}
