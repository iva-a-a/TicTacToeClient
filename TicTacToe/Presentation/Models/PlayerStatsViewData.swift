//
//  PlayerStatsViewData.swift
//  TicTacToe

import Foundation

struct PlayerStatsViewData: Identifiable {
    var id: UUID
    let position: Int
    let login: String
    let winRatioText: String
}
