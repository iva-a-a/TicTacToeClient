//
//  NewGameViewModel.swift
//  TicTacToe

import SwiftUI
import Foundation

@MainActor
final class NewGameViewModel: BaseViewModel, @MainActor HasCurrentUserService {
    private let coordinator: AppCoordinator
    private let apiService: ApiServiceProtocol
    let currentUserService: CurrentUserServiceProtocol

    init(coordinator: AppCoordinator,
         apiService: ApiServiceProtocol,
         currentUserService: CurrentUserServiceProtocol,
         errorHandler: ErrorHandlerProtocol) {
        
        self.coordinator = coordinator
        self.apiService = apiService
        self.currentUserService = currentUserService
        
        super.init(errorHandler: errorHandler)
    }
        
    func createGame(withAI: Bool) {
        performWithLoading {
            await self.withCurrentUser { me in
                let request = NewGameRequestDto(creatorLogin: me.login, playWithAI: withAI)
                let dto = try await self.apiService.createGame(request)
                let domain = GameMapper.toDomain(dto)
                self.coordinator.navigate(to: .currentGame(id: domain.id))
            }
        }
    }
}
