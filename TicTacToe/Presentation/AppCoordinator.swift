//
//  AppCoordinator.swift
//  TicTacToe

import SwiftUI
import Combine

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to screen: AppScreen) {
        path.append(screen)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func reset() {
        path.removeLast(path.count)
    }
}
