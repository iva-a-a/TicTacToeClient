//
//  SessionService.swift
//  TicTacToe

import Foundation

@MainActor
final class SessionService: SessionServiceProtocol {
    private let currentUserService: CurrentUserServiceProtocol
    private let gameService: GameServiceProtocol
    private let userService: UserServiceProtocol
    private let coordinator: AppCoordinator

    init(currentUserService: CurrentUserServiceProtocol,
         gameService: GameServiceProtocol,
         userService: UserServiceProtocol,
         coordinator: AppCoordinator) {
        self.currentUserService = currentUserService
        self.gameService = gameService
        self.userService = userService
        self.coordinator = coordinator
    }

    func resetSession() async throws {
        do {
            try await currentUserService.clearCurrentUser()
            let games = try await gameService.getAllGames()
            for game in games {
                try await gameService.deleteGame(by: game.id)
            }
            let allUsers = try await userService.getAllUsers()
            for user in allUsers {
                try await userService.deleteUser(user: user)
            }
              coordinator.reset()
          } catch {
              throw error
          }
      }
  }
