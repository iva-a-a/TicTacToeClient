//
//  LeaderboardServiceProtocol.swift
//  TicTacToe

import Foundation

protocol LeaderboardServiceProtocol {
    func createStats(stats: PlayerStatsDomain) async throws
    func updateStats(stats: PlayerStatsDomain) async throws
    func getStats(by id: UUID) async throws -> PlayerStatsDomain
    func getAllStats() async throws -> [PlayerStatsDomain]
    func deleteStats(by id: UUID) async throws
    func deleteAllStats() async throws
}
