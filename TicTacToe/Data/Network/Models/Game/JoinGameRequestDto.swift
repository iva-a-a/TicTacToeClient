//
//  JoinGameRequestDto.swift
//  TicTacToe

import Foundation

struct JoinGameRequestDto: Codable {
    let playerId: UUID
    let playerLogin: String
}
