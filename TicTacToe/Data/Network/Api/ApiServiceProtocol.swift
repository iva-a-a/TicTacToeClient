//
//  ApiServiceProtocol.swift
//  TicTacToe

import Foundation

protocol ApiServiceProtocol {
    func signUp(_ request: SignUpRequestDto) async throws -> UserIdDto
    func signIn() async throws -> UserIdDto
    func createGame(_ request: NewGameRequestDto) async throws -> GameDto
    func getAvailableGames() async throws -> AvailableGamesDto
    func getInProgressGames() async throws -> AvailableGamesDto
    func joinGame(gameId: UUID, request: JoinGameRequestDto) async throws -> GameDto
    func getGame(gameId: UUID) async throws -> GameDto
    func makeMove(gameId: UUID, request: MoveRequestDto) async throws -> GameDto
    func getUser(userId: UUID) async throws -> UserDto
}

