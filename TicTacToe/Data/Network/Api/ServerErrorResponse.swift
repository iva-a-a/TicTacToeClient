//
//  ServerErrorResponse.swift
//  TicTacToe

struct ServerErrorResponse: Decodable {
    let error: Bool
    let reason: String?
}
