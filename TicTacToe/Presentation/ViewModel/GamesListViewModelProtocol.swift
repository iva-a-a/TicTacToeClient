//
//  GamesListViewModelProtocol.swift
//  TicTacToe

import SwiftUI

protocol GamesListViewModelProtocol: ObservableObject {
    var games: [GameViewData] { get }
    var isLoading: Bool { get }
    var alertMessage: String? { get set }

    func fetchGames()
    func refreshGames() async
}

extension AvailableGamesViewModel: @MainActor GamesListViewModelProtocol {
    func fetchGames() { fetchAvailableGames() }
}

extension InProgressGamesViewModel: @MainActor GamesListViewModelProtocol {
    func fetchGames() { fetchUnfinishedGames() }
}
