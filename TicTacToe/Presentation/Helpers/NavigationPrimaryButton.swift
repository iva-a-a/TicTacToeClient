//
//  NavigationPrimaryButton.swift
//  TicTacToe

import SwiftUI

struct NavigationPrimaryButton: View {
    let title: String
    let icon: String?
    let color: Color
    let coordinator: AppCoordinator
    let destination: AppScreen

    var body: some View {
        PrimaryButton(title: title, systemImage: icon, color: color) {
            coordinator.navigate(to: destination)
        }
    }
}
