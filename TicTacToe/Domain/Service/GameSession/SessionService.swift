//
//  SessionService.swift
//  TicTacToe

import Foundation

final class SessionService: SessionServiceProtocol {
    private let currentUserService: CurrentUserServiceProtocol
    private let gameService: GameServiceProtocol
    private let userService: UserServiceProtocol
    private let leaderboardService: LeaderboardServiceProtocol
    private let tokenRepository: TokenRepositoryProtocol

    init(currentUserService: CurrentUserServiceProtocol,
         gameService: GameServiceProtocol,
         userService: UserServiceProtocol,
         leaderboardService: LeaderboardServiceProtocol,
         tokenRepository: TokenRepositoryProtocol) {
        self.currentUserService = currentUserService
        self.gameService = gameService
        self.userService = userService
        self.leaderboardService = leaderboardService
        self.tokenRepository = tokenRepository
    }
    
    func resetSession() async throws {
        try await currentUserService.clearCurrentUser()
        try await gameService.deleteAllGames()
        try await userService.deleteAllUsers()
        try await tokenRepository.clear()
        try await leaderboardService.deleteAllStats()
    }
}
