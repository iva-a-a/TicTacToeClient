//
//  JwtResponseDto.swift
//  TicTacToe

import Foundation

struct JwtResponseDto: Codable {
    let type: String
    let accessToken: String
    let refreshToken: String
}
