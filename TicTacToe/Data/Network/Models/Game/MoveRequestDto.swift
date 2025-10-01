//
//  MoveRequestDto.swift
//  TicTacToe

import Foundation

struct MoveRequestDto: Codable {
    let playerId: UUID
    let row: Int
    let col: Int
}
