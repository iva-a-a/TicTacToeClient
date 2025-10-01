//
//  GameViewMapper.swift
//  TicTacToe

import Foundation

struct GameViewMapper {
    
    static func toViewData(_ domain: GameDomain, currentUserId: UUID?) -> GameViewData {
    
        let playersView = domain.players.map { PlayerViewData(id: $0.id, login: $0.login ?? "Unknown", tile: tileForView(tileDomain: $0.tile)) }

        let state = stateForView(currentUserId: currentUserId, state: domain.state, players: domain.players)

        let boardView = BoardViewData(grid: gridForView(domain.board.grid))
        
        let creator = playersView.first { player in player.tile == .x }?.login

        return GameViewData(
            id: domain.id,
            players: playersView,
            state: state,
            board: boardView,
            withAI: domain.withAI,
            creator: creator ?? "Unknown"
        )
    }
    
    private static func stateForView(currentUserId: UUID?, state: GameStateDomain, players: [PlayerDomain]) -> ViewState {
        switch state {
        case .waitingForPlayers:
            return .waitingForPlayers
        case .playerTurn(let playerId):
            if let current = currentUserId, playerId == current {
                return .yourTurn
            } else {
                let opponent = players.first(where: { $0.id == playerId })
                return .opponentsTurn(login: opponent?.login)
            }
        case .draw:
            return .draw
        case .winner(let winnerId):
            if let current = currentUserId, winnerId == current {
                return .victory
            } else {
                return .defeat
            }
        }
    }
    
    private static func tileForView(tileDomain: TileDomain) -> TileView {
        switch tileDomain {
        case .empty: return TileView.empty
        case .o: return TileView.o
        case .x: return TileView.x
        }
    }
    
    private static func gridForView(_ grid: [[TileDomain]]) -> [[TileView]] {
        grid.map { row in
            row.map { tileDomain in
                tileForView(tileDomain: tileDomain)
            }
        }
    }
}
