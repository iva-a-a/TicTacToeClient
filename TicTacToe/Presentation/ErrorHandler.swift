//
//  ErrorHandler.swift
//  TicTacToe

import Foundation

final class ErrorHandler: ErrorHandlerProtocol {
    private let strategy: ErrorHandlingStrategy
    private weak var coordinator: AppCoordinator?

    init(strategy: ErrorHandlingStrategy, coordinator: AppCoordinator?) {
        self.strategy = strategy
        self.coordinator = coordinator
    }

    @MainActor
    func handle(_ error: Error) async -> ErrorResolution {
        if strategy.canHandle(error) {
            let resolution = await strategy.handle(error)
            if case .logout(_) = resolution {
                coordinator?.reset()
            }
            return resolution
        } else {
            return .message(error.localizedDescription)
        }
    }
}
