//
//  AuthInterceptor.swift
//  TicTacToe

import Foundation

struct AuthInterceptor {
    static func authHeader(tokenRepository: TokenRepositoryProtocol = TokenRepository.shared) -> String? {
        guard let accessToken = tokenRepository.accessToken else { return nil }
        return "Bearer \(accessToken)"
    }
}
