//
//  GameDto.swift
//  TicTacToe

import Foundation

struct GameDto: Codable {
    let id: UUID
    let board: BoardDto
    let state: GameStateDto
    let players: [PlayerDto]
    let withAI: Bool
}
