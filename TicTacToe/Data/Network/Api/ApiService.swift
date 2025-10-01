//
//  ApiService.swift
//  TicTacToe

import Foundation

struct EmptyBody: Encodable {}

final class ApiService: ApiServiceProtocol {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func signUp(_ request: SignUpRequestDto) async throws -> UserIdDto {
        try await client.post(Endpoints.signUp.path, body: request)
    }
    
    func signIn() async throws -> UserIdDto {
        try await client.post(Endpoints.signIn.path, body: EmptyBody())
    }
    
    func createGame(_ request: NewGameRequestDto) async throws -> GameDto {
        try await client.post(Endpoints.newGame.path, body: request)
    }
    
    func getAvailableGames() async throws -> AvailableGamesDto {
        try await client.get(Endpoints.availableGames.path)
    }
    
    func joinGame(gameId: UUID, request: JoinGameRequestDto) async throws -> GameDto {
        try await client.post(Endpoints.joinGame(gameId).path, body: request)
    }
    
    func getGame(gameId: UUID) async throws -> GameDto {
        try await client.get(Endpoints.getGame(gameId).path)
    }
    
    func makeMove(gameId: UUID, request: MoveRequestDto) async throws -> GameDto {
        try await client.post(Endpoints.makeMove(gameId).path, body: request)
    }
    
    func getUser(userId: UUID) async throws -> UserDto {
        try await client.get(Endpoints.getUser(userId).path)
    }
    
    func getInProgressGames() async throws -> AvailableGamesDto {
        try await client.get(Endpoints.inProgressGames.path)
    }
}
