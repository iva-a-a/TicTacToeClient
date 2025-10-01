//
//  PlayerDto.swift
//  TicTacToe

import Foundation

struct PlayerDto: Codable {
    let id: UUID
    let login: String?
    let tile: TileDto
}
