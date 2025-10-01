//
//  TileDto.swift
//  TicTacToe

import Foundation

enum TileDto: Int, Codable {
    case empty = 0
    case x = 1
    case o = 2
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        self = TileDto(rawValue: rawValue) ?? .empty
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
