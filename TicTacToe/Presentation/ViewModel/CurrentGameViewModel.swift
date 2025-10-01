//
//  CurrentGameViewModel.swift
//  TicTacToe

import Foundation
import SwiftUI

@MainActor
final class CurrentGameViewModel: BaseViewModel, @MainActor HasCurrentUserService {
    @Published var game: GameViewData?

    private let gameId: UUID
    private let apiService: ApiServiceProtocol
    let currentUserService: CurrentUserServiceProtocol
    private let gameService: GameServiceProtocol
    private let coordinator: AppCoordinator
    private var timer: Timer?

    init(gameId: UUID,
         apiService: ApiServiceProtocol,
         currentUserService: CurrentUserServiceProtocol,
         gameService: GameServiceProtocol,
         coordinator: AppCoordinator,
         errorHandler: ErrorHandlerProtocol) {
        
        self.gameId = gameId
        self.apiService = apiService
        self.currentUserService = currentUserService
        self.gameService = gameService
        self.coordinator = coordinator

        super.init(errorHandler: errorHandler)
    }

    func start() {
        Task { await fetchGame() }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { await self?.fetchGame() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func fetchGame() async {
        performWithLoading {
            do {
                let dto = try await self.apiService.getGame(gameId: self.gameId)
                let domain = GameMapper.toDomain(dto)
                try await self.upsert(game: domain)
                
                await self.withCurrentUser { me in
                    self.game = GameViewMapper.toViewData(domain, currentUserId: me.id)
                }
            } catch {
                await self.handleError(error)
            }
        }
    }

    func makeMove(row: Int, col: Int) async {
        performWithLoading {
            await self.withCurrentUser { me in
                let dto = try await self.apiService.makeMove(
                    gameId: self.gameId,
                    request: MoveRequestDto(playerId: me.id, row: row, col: col)
                )
                let domain = GameMapper.toDomain(dto)
                try await self.upsert(game: domain)
                self.game = GameViewMapper.toViewData(domain, currentUserId: me.id)
            }
        }
    }

    private func upsert(game: GameDomain) async throws {
        do {
            _ = try await gameService.updateGame(game: game)
        } catch DatabaseError.gameNotFound {
            _ = try await gameService.createGame(game: game)
        }
    }
    
    func canMakeMove(game: GameViewData) -> Bool {
        return game.state == .yourTurn
    }
}
