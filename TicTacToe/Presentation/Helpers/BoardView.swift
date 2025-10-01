//
//  BoardView.swift
//  TicTacToe

import SwiftUI

struct BoardView: View {
    let grid: [[TileView]]
    let action: (Int, Int) -> Void

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.9
            VStack(spacing: 2) {
                ForEach(0..<grid.count, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<grid[row].count, id: \.self) { col in
                            CellView(tile: grid[row][col]) {
                                action(row, col)
                            }
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
