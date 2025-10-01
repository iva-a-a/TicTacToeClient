//
//  AvailableGamesViewModel.swift
//  TicTacToe

import Foundation
import SwiftUI

@MainActor
final class AvailableGamesViewModel: BaseViewModel, GamesFetchable, @MainActor HasCurrentUserService {
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
    
    func fetchAvailableGames() {
        performWithLoading {
            await self.fetchGamesFromAPI {
                try await self.apiService.getAvailableGames()
            }
        }
    }

    func refreshGames() async {
        await fetchGamesFromAPI {
            try await self.apiService.getAvailableGames()
        }
    }
    
    func joinGame(gameId: UUID) {
        performWithLoading {
            await self.withCurrentUser { me in
                let dto = try await self.apiService.joinGame(
                    gameId: gameId,
                    request: JoinGameRequestDto(playerId: me.id, playerLogin: me.login)
                )
                let domain = GameMapper.toDomain(dto)
                self.coordinator.navigate(to: .currentGame(id: domain.id))
            }
        }
    }
}
