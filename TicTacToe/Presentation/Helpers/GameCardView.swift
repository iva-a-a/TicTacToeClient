//
//  GameCardView.swift
//  TicTacToe

import SwiftUI

struct GameCardView: View {
    let game: GameViewData
    let onTap: () -> Void
    let statusColor: Color

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Game #\(game.id.shortString)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Creator: \(game.creator)")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text("Status: \(game.state.title)")
                        .font(.caption)
                        .foregroundColor(statusColor)
                }
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

extension UUID {
    var shortString: String { uuidString.prefix(8).description }
}
