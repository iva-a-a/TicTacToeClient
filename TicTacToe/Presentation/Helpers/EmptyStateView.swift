//
//  EmptyStateView.swift
//  TicTacToe

import SwiftUI

struct EmptyStateView: View {
    let image: String
    let title: String
    let subtitle: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: image)
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))

            Text(title)
                .font(.headline)
                .foregroundColor(.gray)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let buttonTitle, let action = buttonAction {
                PrimaryButton(title: buttonTitle) { action() }
                    .padding(.top, 8)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
