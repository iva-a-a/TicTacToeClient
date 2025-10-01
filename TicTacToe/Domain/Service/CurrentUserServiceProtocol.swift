//
//  CurrentUserServiceProtocol.swift
//  TicTacToe

import Foundation

protocol CurrentUserServiceProtocol {
    func setCurrentUser(user: UserDomain) async throws
    func getCurrentUser() async throws -> UserDomain?
    func clearCurrentUser() async throws
}
