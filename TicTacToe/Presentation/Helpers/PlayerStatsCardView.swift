//
//  PlayerStatsCardView.swift
//  TicTacToe

import SwiftUI

struct PlayerStatsCardView: View {
    let player: PlayerStatsViewData

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 32, height: 32)
                if let icon = medalIcon(for: player.position) {
                    Image(systemName: icon)
                        .foregroundColor(medalColor(for: player.position))
                        .font(.system(size: 15, weight: .semibold))
                } else {
                    Text("\(player.position)")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                }
            }
            .frame(width: 40, alignment: .leading)

            Text(player.login)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)

            Text(player.winRatioText)
                .font(.headline)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }

    private func medalIcon(for position: Int) -> String? {
        switch position {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "rosette"
        default: return nil
        }
    }

    private func medalColor(for position: Int) -> Color {
        switch position {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .primary
        }
    }
}
