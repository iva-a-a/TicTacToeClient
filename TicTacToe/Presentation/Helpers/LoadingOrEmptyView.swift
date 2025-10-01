//
//  LoadingOrEmptyView.swift
//  TicTacToe

import SwiftUI

struct LoadingOrEmptyView<Content: View>: View {
    let isLoading: Bool
    let itemsCount: Int
    let emptyView: EmptyStateView
    let content: () -> Content

    var body: some View {
        Group {
            if isLoading && itemsCount == 0 {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 50)
            } else if itemsCount == 0 {
                emptyView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 50)
            } else {
                content()
            }
        }
    }
}
