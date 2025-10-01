//
//  BoardDto.swift
//  TicTacToe

import Foundation

struct BoardDto: Codable {
    let grid: [[TileDto]]
    
    init(grid: [[TileDto]]) {
        self.grid = grid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawGrid = try container.decode([[Int]].self, forKey: .grid)
        self.grid = rawGrid.map { $0.map { TileDto(rawValue: $0) ?? .empty } }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let rawGrid = grid.map { $0.map { $0.rawValue } }
        try container.encode(rawGrid, forKey: .grid)
    }
    
    private enum CodingKeys: String, CodingKey {
        case grid
    }
}
