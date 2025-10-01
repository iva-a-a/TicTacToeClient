//
//  CreateGameButton.swift
//  TicTacToe

import SwiftUI

struct CreateGameButton: View {
    let coordinator: AppCoordinator

    var body: some View {
        NavigationPrimaryButton(
            title: "Create Game",
            icon: "plus.circle.fill",
            color: .blue,
            coordinator: coordinator,
            destination: .newGame
        )
        .frame(maxWidth: .infinity)
    }
}
