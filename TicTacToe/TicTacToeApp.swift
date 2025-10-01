//
//  TicTacToeApp.swift
//  TicTacToe

import SwiftUI

@main
struct TicTacToeApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
