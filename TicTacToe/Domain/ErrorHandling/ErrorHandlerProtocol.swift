//
//  ErrorHandlerProtocol.swift
//  TicTacToe

import Foundation

protocol ErrorHandlerProtocol {
    func handle(_ error: Error) async -> ErrorResolution
}
