//
//  GameDomain.swift
//  TicTacToe

import Foundation

public enum GameStateDomain: Codable, Sendable, Equatable {
    case waitingForPlayers
    case playerTurn(UUID)
    case draw
    case winner(UUID)
}

public struct PlayerDomain: Codable, Sendable {
    public let id: UUID
    public var login: String?
    public let tile: TileDomain
    
    public init(id: UUID, login: String? = nil, tile: TileDomain) {
        self.id = id
        self.login = login
        self.tile = tile
    }
}

public struct GameDomain: Sendable {
    public let board: BoardDomain
    public let id: UUID
    public let state: GameStateDomain
    public let players: [PlayerDomain]
    public let withAI: Bool
    
    public init(id: UUID, board: BoardDomain, state: GameStateDomain = .waitingForPlayers, players: [PlayerDomain] = [], withAI: Bool) {
        self.id = id
        self.board = board
        self.state = state
        self.players = players
        self.withAI = withAI
    }
}
