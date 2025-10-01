//
//  GamesContainerViewModel.swift
//  TicTacToe

import Foundation
import SwiftUI

@MainActor
final class GamesContainerViewModel: BaseViewModel {
    
    private let sessionService: SessionServiceProtocol
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator,
         sessionService: SessionServiceProtocol,
         errorHandler: ErrorHandlerProtocol) {
        
        self.coordinator = coordinator
        self.sessionService = sessionService
        
        super.init(errorHandler: errorHandler)
    }
    
    func logout() {
        performWithLoading {
            do {
                try await self.sessionService.resetSession()
            } catch {
                await self.handleError(error)
            }
        }
    }
}
