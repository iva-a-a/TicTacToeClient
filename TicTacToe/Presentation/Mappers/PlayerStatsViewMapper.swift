//
//  PlayerStatsViewMapper.swift
//  TicTacToe

import Foundation

struct PlayerStatsViewMapper {

    static func toViewData(_ domain: PlayerStatsDomain, position: Int) -> PlayerStatsViewData {
        let ratioNumber = NSNumber(value: domain.winRatio)
        let text = percentFormatter.string(from: ratioNumber) ?? "-"
        return PlayerStatsViewData(id: UUID(),
                                   position: position,
                                   login: domain.login,
                                   winRatioText: text)
    }
    
    private static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter
    }()

}
