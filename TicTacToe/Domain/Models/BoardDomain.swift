//
//  BoardDomain.swift
//  TicTacToe

import Foundation

public enum TileDomain: Int, Codable, Sendable {
    case empty = 0
    case x = 1
    case o = 2
}

public struct BoardDomain: Sendable {
    public var grid: [[TileDomain]]
    
    public init(grid: [[TileDomain]]) {
        self.grid = grid
    }
}
