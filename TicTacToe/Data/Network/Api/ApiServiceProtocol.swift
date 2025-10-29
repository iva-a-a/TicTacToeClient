//
//  ApiServiceProtocol.swift
//  TicTacToe

import Foundation

protocol ApiServiceProtocol {
    func signUp(request: SignUpRequestDto) async throws -> UserIdDto
    func signIn(request: SignUpRequestDto) async throws -> JwtResponseDto
    func createGame(request: NewGameRequestDto) async throws -> GameDto
    func getAvailableGames() async throws -> GamesDto
    func getInProgressGames() async throws -> GamesDto
    func joinGame(gameId: UUID, request: JoinGameRequestDto) async throws -> GameDto
    func getGame(gameId: UUID) async throws -> GameDto
    func makeMove(gameId: UUID, request: MoveRequestDto) async throws -> GameDto
    func getUser(userId: UUID) async throws -> UserDto
    func getFinishedGames() async throws -> GamesDto
    func getTopPlayers(limit: Int) async throws -> PlayersStatsDto
    func refreshAccessToken(request: RefreshJwtRequestDto) async throws -> JwtResponseDto
    func refreshRefreshToken(request: RefreshJwtRequestDto) async throws -> JwtResponseDto
    func getMe() async throws -> UserDto
}

