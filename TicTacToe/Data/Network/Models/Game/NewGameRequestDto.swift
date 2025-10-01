//
//  NewGameRequestDto.swift
//  TicTacToe

import Foundation

struct NewGameRequestDto: Codable {
    let creatorLogin: String
    let playWithAI: Bool
}
