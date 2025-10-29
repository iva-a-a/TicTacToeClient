//
//  TokenRepositoryProtocol.swift
//  TicTacToe

import Foundation

protocol TokenRepositoryProtocol: Sendable {
    var accessToken: String? { get }
    var refreshToken: String? { get }

    @MainActor
    func save(token: TokenModel) async throws
    @MainActor
    func clear() async throws
}
