//
//  AppScreens.swift
//  TicTacToe

import SwiftUI

enum AppScreen: Hashable {
    case signIn
    case signUp
    case newGame
    case currentGame(id: UUID)
    case games
}
