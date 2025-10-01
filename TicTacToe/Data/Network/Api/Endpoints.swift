//
//  Endpoints.swift
//  TicTacToe

import Foundation

enum Endpoints {
    static let baseURL = "http://localhost:8080"

    case signUp
    case signIn
    case newGame
    case availableGames
    case inProgressGames
    case joinGame(UUID)
    case getGame(UUID)
    case makeMove(UUID)
    case getUser(UUID)

    var path: String {
        switch self {
        case .signUp: return "/signup"
        case .signIn: return "/signin"
        case .newGame: return "/newgame"
        case .availableGames: return "/games/available"
        case .inProgressGames: return "/games/inprogress"
        case .joinGame(let id): return "/game/\(id.uuidString)/join"
        case .getGame(let id): return "/game/\(id.uuidString)"
        case .makeMove(let id): return "/game/\(id.uuidString)/move"
        case .getUser(let id): return "/user/\(id.uuidString)"
        }
    }
}
