//
//  DatabaseError.swift
//  TicTacToe

import Foundation

enum DatabaseError: Error, LocalizedError {
    case userNotFound
    case gameNotFound
    case currentUserNotSet
    case alreadyExists(String)
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .userNotFound: return "User not found"
        case .gameNotFound: return "Game not found"
        case .currentUserNotSet: return "Current user not set"
        case .alreadyExists(let entity): return "\(entity) already exists"
        case .unknownError(let message): return "Unknown error: \(message)"
        }
    }
}
