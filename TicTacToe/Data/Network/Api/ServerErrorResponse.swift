//
//  ServerErrorResponse.swift
//  TicTacToe

import Foundation

struct ServerErrorResponse: Decodable {
    let error: Bool
    let reason: String?
}
