//
//  SignUpRequestDto.swift
//  TicTacToe

import Foundation

struct SignUpRequestDto: Codable {
    let login: String
    let password: String
}
