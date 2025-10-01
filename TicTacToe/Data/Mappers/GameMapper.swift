//
//  GameMapper.swift
//  TicTacToe

import Foundation
import CoreData

struct GameMapper {
    static func toDomain(_ entity: GameEntity) -> GameDomain {
        
        let gridArray = entity.gridArray
        let tiles = gridArray.map { row in
            row.map { TileDomain(rawValue: $0) ?? .empty } }
        let board = BoardDomain(grid: tiles)
        let state = StateMapper.toDomain(state: entity.state ?? "waiting",
                                         currentTurnPlayerId: entity.current_turn_player_id,
                                         winnerId: entity.winner_id,
                                         isDraw: entity.is_draw)
        let players = PlayersMapper.toDomain(playerXId: entity.playerX_id,
                                             playerOId: entity.playerO_id,
                                             playerXLogin: entity.playerX_login,
                                             playerOLogin: entity.playerO_login)
        
        return GameDomain(id: entity.id ?? UUID(),
                          board: board,
                          state: state,
                          players: players,
                          withAI: entity.with_AI)
    }
    
    static func toEntity(_ domain: GameDomain, context: NSManagedObjectContext) -> GameEntity {
        let entity = GameEntity(context: context)
        
        let intGrid = domain.board.grid.map { row in
            row.map { $0.rawValue } }
        let (state, currentTurnPlayerId, winnerId, isDraw) = StateMapper.toEntity(domain.state)
        let (playerXId, playerOId, playerXLogin, playerOLogin) = PlayersMapper.toEntity(domain.players)
        
        entity.id = domain.id
        entity.gridArray = intGrid
        entity.state = state
        entity.playerX_id = playerXId
        entity.playerO_id = playerOId
        entity.playerX_login = playerXLogin
        entity.playerO_login = playerOLogin
        entity.current_turn_player_id = currentTurnPlayerId
        entity.winner_id = winnerId
        entity.is_draw = isDraw
        entity.with_AI = domain.withAI
        
        return entity
    }
    
    static func toDomain(_ dto: GameDto) -> GameDomain {
        let board = BoardMapper.toDomain(dto.board)
        let players = dto.players.map { PlayerMapper.toDomain($0) }
        let state = StateMapper.toDomain(dto.state)
        
        return GameDomain(id: dto.id,
                          board: board,
                          state: state,
                          players: players,
                          withAI: dto.withAI)
    }
    
    static func toDto(_ domain: GameDomain) -> GameDto {
        let boardDto = BoardMapper.toDto(domain.board)
        let playersDto = domain.players.map { PlayerMapper.toDto($0) }
        let state = StateMapper.toDto(domain.state)
        
        return GameDto(id: domain.id,
                       board: boardDto,
                       state: state,
                       players: playersDto,
                       withAI: domain.withAI)
    }
}

struct StateMapper {
    static func toDomain(state: String,
                         currentTurnPlayerId: UUID?,
                         winnerId: UUID?,
                         isDraw: Bool) -> GameStateDomain {
        switch state {
        case "waiting":
            return .waitingForPlayers
        case "inProgress":
            if let turnId = currentTurnPlayerId {
                return .playerTurn(turnId)
            } else {
                return .waitingForPlayers
            }
        case "finished":
            if isDraw {
                return .draw
            } else if let winnerId = winnerId {
                return .winner(winnerId)
            } else {
                return .draw
            }
        default:
            return .waitingForPlayers
        }
    }
    
    static func toEntity(_ domain: GameStateDomain) -> (String, UUID?, UUID?, Bool) {
        switch domain {
        case .waitingForPlayers:
            return ("waiting", nil, nil, false)
        case .playerTurn(let id):
            return ("inProgress", id, nil, false)
        case .draw:
            return ("finished", nil, nil, true)
        case .winner(let id):
            return ("finished", nil, id, false)
        }
    }
    
    static func toDomain(_ dto: GameStateDto) -> GameStateDomain {
        switch dto {
        case .waitingForPlayers: return .waitingForPlayers
        case .playerTurn(let id): return .playerTurn(id)
        case .draw: return .draw
        case .winner(let id): return .winner(id)
        }
    }
    
    static func toDto(_ domain: GameStateDomain) -> GameStateDto {
        switch domain {
        case .waitingForPlayers: return .waitingForPlayers
        case .playerTurn(let id): return .playerTurn(id)
        case .draw: return .draw
        case .winner(let id): return .winner(id)
        }
    }
}

struct PlayersMapper {
    static func toDomain(playerXId: UUID?, playerOId: UUID?, playerXLogin loginX: String?, playerOLogin loginO: String?) -> [PlayerDomain] {
        var result: [PlayerDomain] = []
        
        if let x = playerXId {
            result.append(PlayerDomain(id: x,login: loginX, tile: .x))
        }
        if let o = playerOId {
            result.append(PlayerDomain(id: o, login: loginO, tile: .o))
        }
        
        return result
    }
    
    static func toEntity(_ domainList: [PlayerDomain]) -> (UUID?, UUID?, String?, String?) {
        var x: UUID? = nil
        var o: UUID? = nil
        var loginX: String? = nil
        var loginO: String? = nil
        
        for player in domainList {
            switch player.tile {
            case .x:
                x = player.id
                loginX = player.login
            case .o:
                o = player.id
                loginO = player.login
            default: break
            }
        }
        return (x, o, loginX, loginO)
    }
}

struct PlayerMapper {
    static func toDomain(_ dto: PlayerDto) -> PlayerDomain {
        let tile: TileDomain
        switch dto.tile {
        case .empty: tile = TileDomain.empty
        case .x: tile = TileDomain.x
        case .o: tile = TileDomain.o
        }
        return PlayerDomain(id: dto.id, login: dto.login, tile: tile)
    }
    
    static func toDto(_ domain: PlayerDomain) -> PlayerDto {
        let tile: TileDto
        switch domain.tile {
        case .empty: tile = TileDto.empty
        case .x: tile = TileDto.x
        case .o: tile = TileDto.o
        }
        return PlayerDto(id: domain.id, login: domain.login, tile: tile)
    }
}


struct BoardMapper {
    static func toDomain(_ dto: BoardDto) -> BoardDomain {
        let grid = dto.grid.map { row in
            row.map { tileDto in
                switch tileDto {
                case .empty: return TileDomain.empty
                case .x: return TileDomain.x
                case .o: return TileDomain.o
                }
            }
        }
        return BoardDomain(grid: grid)
    }
    
    static func toDto(_ domain: BoardDomain) -> BoardDto {
        let grid = domain.grid.map { row in
            row.map { tile in
                switch tile {
                case .empty: return TileDto.empty
                case .x: return TileDto.x
                case .o: return TileDto.o
                }
            }
        }
        return BoardDto(grid: grid)
    }
}
