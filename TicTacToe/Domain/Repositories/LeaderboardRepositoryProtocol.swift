//
//  LeaderboardRepositoryProtocol.swift
//  TicTacToe

import Foundation

protocol LeaderboardRepositoryProtocol {
    func create(stats: PlayerStatsDomain) async throws
    func update(stats: PlayerStatsDomain) async throws
    func get(by id: UUID) async throws -> PlayerStatsDomain?
    func getAll() async throws -> [PlayerStatsDomain]
    func delete(by id: UUID) async throws
    func deleteAll() async throws 
}
