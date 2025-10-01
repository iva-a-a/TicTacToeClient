//
//  GameCardBuilder.swift
//  TicTacToe

import SwiftUI

struct GameCardBuilder: View {
    let game: GameViewData
    let action: () -> Void

    var body: some View {
        GameCardView(game: game, onTap: action, statusColor: game.state.color)
    }
}
