//
//  TokenMapper.swift
//  TicTacToe

import Foundation

struct TokenMapper {
    static func toModel(_ dto: JwtResponseDto) -> TokenModel {
        return TokenModel(type: dto.type, accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
}
