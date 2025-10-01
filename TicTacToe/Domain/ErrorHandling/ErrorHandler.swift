//
//  ErrorHandler.swift
//  TicTacToe

import Foundation

@MainActor
final class ErrorHandler: ErrorHandlerProtocol {
    private let strategy: ErrorHandlingStrategy

    init(strategy: ErrorHandlingStrategy) {
        self.strategy = strategy
    }

    func handle(_ error: Error) async -> ErrorResolution {
        if strategy.canHandle(error) {
            return await strategy.handle(error)
        } else {
            return .message(error.localizedDescription)
        }
    }
}
