//
//  GameDomain.swift
//  TicTacToe

import Foundation

enum GameStateDomain: Codable, Sendable, Equatable {
    case waitingForPlayers
    case playerTurn(UUID)
    case draw
    case winner(UUID)
}

struct PlayerDomain: Codable, Sendable {
    let id: UUID
    var login: String?
    let tile: TileDomain
    
    init(id: UUID, login: String? = nil, tile: TileDomain) {
        self.id = id
        self.login = login
        self.tile = tile
    }
}

struct GameDomain: Sendable {
    let board: BoardDomain
    let id: UUID
    let state: GameStateDomain
    let players: [PlayerDomain]
    let withAI: Bool
    let dateСreation: String
    
    init(id: UUID, board: BoardDomain, state: GameStateDomain = .waitingForPlayers, players: [PlayerDomain] = [], withAI: Bool, dateCreation: String) {
        self.id = id
        self.board = board
        self.state = state
        self.players = players
        self.withAI = withAI
        self.dateСreation = dateCreation
    }
}
