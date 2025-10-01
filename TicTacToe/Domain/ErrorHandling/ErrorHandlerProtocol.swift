//
//  ErrorHandlerProtocol.swift
//  TicTacToe

import Foundation

@MainActor
protocol ErrorHandlerProtocol {
    func handle(_ error: Error) async -> ErrorResolution
}
