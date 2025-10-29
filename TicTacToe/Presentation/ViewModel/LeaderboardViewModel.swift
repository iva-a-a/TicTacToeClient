//
//  LeaderboardViewModel.swift
//  TicTacToe

import Foundation

@MainActor
final class LeaderboardViewModel: BaseViewModel, @MainActor HasCurrentUserService {

    @Published var players: [PlayerStatsViewData] = []

    let currentUserService: CurrentUserServiceProtocol
    private let apiService: ApiServiceProtocol

    init(
        apiService: ApiServiceProtocol,
        currentUserService: CurrentUserServiceProtocol,
        errorHandler: ErrorHandlerProtocol
    ) {
        self.apiService = apiService
        self.currentUserService = currentUserService
        super.init(errorHandler: errorHandler)
    }

    func loadTopPlayers(limit: Int = 20) {
        performWithLoading {
            await self.withCurrentUser { _ in
                do {
                    let dto = try await self.apiService.getTopPlayers(limit: limit)
                    let domains = dto.playersStats.map {
                        PlayerStatsDomain(
                            userId: $0.userId,
                            login: $0.login,
                            winRatio: $0.winRatio
                        )
                    }
                    self.players = domains.enumerated().map { index, domain in
                        PlayerStatsViewMapper.toViewData(domain, position: index + 1)
                    }
                } catch {
                    await self.handleError(error)
                }
            }
        }
    }

    func refresh() async {
        loadTopPlayers()
    }
}
