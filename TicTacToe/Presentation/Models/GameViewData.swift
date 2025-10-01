//
//  GameViewData.swift
//  TicTacToe

import Foundation

struct GameViewData: Identifiable {
    let id: UUID
    let players: [PlayerViewData]
    let state: ViewState
    let board: BoardViewData
    let withAI: Bool
    let creator: String
}

struct PlayerViewData: Identifiable {
    let id: UUID
    let login: String
    let tile: TileView
}

enum TileView: String {
    case empty = ""
    case x = "❌"
    case o = "⭕️"
}

struct BoardViewData {
    let grid: [[TileView]]
}

enum ViewState: Equatable {
    case waitingForPlayers
    case yourTurn
    case opponentsTurn(login: String?)
    case draw
    case victory
    case defeat

    var title: String {
        switch self {
        case .waitingForPlayers: return "Waiting for players"
        case .yourTurn: return "Your turn"
        case .opponentsTurn(let login):
            if let login = login, !login.isEmpty {
                return "\(login)'s turn"
            } else {
                return "Opponent's turn"
            }
        case .draw: return "Draw!"
        case .victory: return "Victory!"
        case .defeat: return "Defeat!"
        }
    }
}
