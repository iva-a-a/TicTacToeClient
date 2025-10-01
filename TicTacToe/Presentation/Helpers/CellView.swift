//
//  CellView.swift
//  TicTacToe

import SwiftUI

struct CellView: View {
    let tile: TileView
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(tile.rawValue)
                .font(.system(size: 50))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(tile == .empty ? Color.gray.opacity(0.1) : Color.blue.opacity(0.3))
                .cornerRadius(4)
        }
        .disabled(tile != .empty)
    }
}
