//
//  GameStateDto.swift
//  TicTacToe

import Foundation

enum GameStateDto: Codable, Equatable {
    case waitingForPlayers
    case playerTurn(UUID)
    case draw
    case winner(UUID)
    
    private enum CodingKeys: String, CodingKey {
        case type
        case playerId
        case winnerId
    }

    private enum StateType: String, Codable {
        case waitingForPlayers
        case playerTurn
        case draw
        case winner
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StateType.self, forKey: .type)
        
        switch type {
        case .waitingForPlayers:
            self = .waitingForPlayers
        case .playerTurn:
            let playerId = try container.decode(UUID.self, forKey: .playerId)
            self = .playerTurn(playerId)
        case .draw:
            self = .draw
        case .winner:
            let winnerId = try container.decode(UUID.self, forKey: .winnerId)
            self = .winner(winnerId)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .waitingForPlayers:
            try container.encode(StateType.waitingForPlayers, forKey: .type)
        case .playerTurn(let playerId):
            try container.encode(StateType.playerTurn, forKey: .type)
            try container.encode(playerId, forKey: .playerId)
        case .draw:
            try container.encode(StateType.draw, forKey: .type)
        case .winner(let winnerId):
            try container.encode(StateType.winner, forKey: .type)
            try container.encode(winnerId, forKey: .winnerId)
        }
    }
}
