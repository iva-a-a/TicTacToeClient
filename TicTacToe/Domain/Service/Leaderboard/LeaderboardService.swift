//
//  LeaderboardService.swift
//  TicTacToe

import Foundation

final class LeaderboardService: LeaderboardServiceProtocol {
    
    private let leaderboardRepository: LeaderboardRepositoryProtocol
    
    init(leaderboardRepository: LeaderboardRepositoryProtocol) {
        self.leaderboardRepository = leaderboardRepository
    }
    
    func createStats(stats: PlayerStatsDomain) async throws {
        try await leaderboardRepository.create(stats: stats)
    }
    
    func updateStats(stats: PlayerStatsDomain) async throws {
        guard let _ = try await leaderboardRepository.get(by: stats.userId) else {
            throw DatabaseError.gameNotFound
        }
        try await leaderboardRepository.update(stats: stats)
    }
    
    func getStats(by id: UUID) async throws -> PlayerStatsDomain {
        guard let stats = try await leaderboardRepository.get(by: id) else {
            throw DatabaseError.gameNotFound
        }
        return stats
    }
    
    func getAllStats() async throws -> [PlayerStatsDomain] {
        return try await leaderboardRepository.getAll()
    }
    
    func deleteStats(by id: UUID) async throws {
        guard try await leaderboardRepository.get(by: id) != nil else {
            throw DatabaseError.gameNotFound
        }
        try await leaderboardRepository.delete(by: id)
    }
        
    func deleteAllStats() async throws {
        try await leaderboardRepository.deleteAll()
    }

}
