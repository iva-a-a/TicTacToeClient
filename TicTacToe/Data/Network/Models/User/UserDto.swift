//
//  UserDto.swift
//  TicTacToe

import Foundation

struct UserDto: Codable {
    let id: UUID
    let login: String
}
