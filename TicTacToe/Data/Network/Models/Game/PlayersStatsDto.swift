//
//  PlayerStatsWeb.swift
//  TicTacToe

import Foundation

struct PlayerStatsDto: Codable {
    let userId: UUID
    let login: String
    let winRatio: Double
}

struct PlayersStatsDto: Codable {
    let playersStats: [PlayerStatsDto]
}
