//
//  GamesFetchable.swift
//  TicTacToe

import Foundation
import SwiftUI

@MainActor
protocol GamesFetchable: ObservableObject {
    var games: [GameViewData] { get set }
    var apiService: ApiServiceProtocol { get }
    var currentUserService: CurrentUserServiceProtocol { get }
    
    func fetchGamesFromAPI(fetch: @escaping () async throws -> AvailableGamesDto) async
}

extension GamesFetchable {
    func fetchGamesFromAPI(fetch: @escaping () async throws -> AvailableGamesDto) async {
        do {
            guard let me = try await currentUserService.getCurrentUser() else { return }
            let dto = try await fetch()
            games = dto.games.map {
                GameViewMapper.toViewData(GameMapper.toDomain($0), currentUserId: me.id)
            }
        } catch {
            if let self = self as? BaseViewModel {
                await self.handleError(error)
            }
        }
    }
}
