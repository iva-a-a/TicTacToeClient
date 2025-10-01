//
//  UserViewMapper.swift
//  TicTacToe

import Foundation

struct UserViewMapper {
    static func toViewData(_ domain: UserDomain) -> UserViewData {
        UserViewData(id: domain.id, login: domain.login)
    }

    static func toDomain(_ viewData: UserViewData, password: String) -> UserDomain {
        UserDomain(id: viewData.id, login: viewData.login, password: password)
    }
}
