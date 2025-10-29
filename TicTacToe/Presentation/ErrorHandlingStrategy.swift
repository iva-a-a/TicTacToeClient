//
//  ErrorHandlingStrategy.swift
//  TicTacToe

import Foundation

protocol ErrorHandlingStrategy {
    func canHandle(_ error: Error) -> Bool
    func handle(_ error: Error) async -> ErrorResolution
}
