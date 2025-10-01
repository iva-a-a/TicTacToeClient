//
//  PrimaryButton.swift
//  TicTacToeы

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String?
    let color: Color
    let isDisabled: Bool
    let action: () -> Void

    init(title: String,
         systemImage: String? = nil,
         color: Color = .blue,
         isDisabled: Bool = false,
         action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : color)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(isDisabled)
    }
}
