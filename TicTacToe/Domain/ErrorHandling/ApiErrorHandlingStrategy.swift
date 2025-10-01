//
//  ApiErrorHandlingStrategy.swift
//  TicTacToe

import Foundation

final class ApiErrorHandlingStrategy: ErrorHandlingStrategy {
    private let sessionService: SessionServiceProtocol

    init(sessionService: SessionServiceProtocol) {
        self.sessionService = sessionService
    }

    func canHandle(_ error: Error) -> Bool {
        return error is ApiError
    }

    func handle(_ error: Error) async -> ErrorResolution {
        guard let apiError = error as? ApiError else { return .silent }

        switch apiError {
        case .unauthorized:
            do {
                try await sessionService.resetSession()
                return .logout("Session expired or invalig login/password. Please sign in again. ")
            } catch {
                return .message("Failed to reset session: \(error.localizedDescription)")
            }
        case .serverError(_, let reason):
            return .message(reason ?? "Server returned an error.")
        case .invalidUrl:
            return .message("Invalid server URL.")
        case .decodingError:
            return .message("Failed to decode server response.")
        case .unknown(let err):
            return .message("Unexpected error: \(err.localizedDescription)")
        }
    }
}
