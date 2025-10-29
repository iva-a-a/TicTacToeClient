//
//  ApiService.swift
//  TicTacToe

import Foundation

final class ApiService: ApiServiceProtocol {
    
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func signUp(request: SignUpRequestDto) async throws -> UserIdDto {
        try await client.post(Endpoints.signUp.url, body: request)
    }
    
    func signIn(request: SignUpRequestDto) async throws -> JwtResponseDto {
        try await client.post(Endpoints.signIn.url, body: request)
    }
    
    func createGame(request: NewGameRequestDto) async throws -> GameDto {
        try await client.post(Endpoints.newGame.url, body: request)
    }
    
    func getAvailableGames() async throws -> GamesDto {
        try await client.get(Endpoints.availableGames.url)
    }
    
    func joinGame(gameId: UUID, request: JoinGameRequestDto) async throws -> GameDto {
        try await client.post(Endpoints.joinGame(gameId).url, body: request)
    }
    
    func getGame(gameId: UUID) async throws -> GameDto {
        try await client.get(Endpoints.getGame(gameId).url)
    }
    
    func makeMove(gameId: UUID, request: MoveRequestDto) async throws -> GameDto {
        try await client.post(Endpoints.makeMove(gameId).url, body: request)
    }
    
    func getUser(userId: UUID) async throws -> UserDto {
        try await client.get(Endpoints.getUser(userId).url)
    }
    
    func getInProgressGames() async throws -> GamesDto {
        try await client.get(Endpoints.inProgressGames.url)
    }
    
    func getFinishedGames() async throws -> GamesDto {
        try await client.get(Endpoints.finishedGames.url)
    }
    
    func getTopPlayers(limit: Int = 20) async throws -> PlayersStatsDto {
        let url = Endpoints.topPlayers.url + "?limit=\(limit)"
        return try await client.get(url)
    }
    
    func refreshAccessToken(request: RefreshJwtRequestDto) async throws -> JwtResponseDto {
        try await client.post(Endpoints.refreshAccess.url, body: request)
    }
    
    func refreshRefreshToken(request: RefreshJwtRequestDto) async throws -> JwtResponseDto {
        try await client.post(Endpoints.refreshRefresh.url, body: request)
    }

    func getMe() async throws -> UserDto {
        try await client.get(Endpoints.getMe.url)
    }
}
