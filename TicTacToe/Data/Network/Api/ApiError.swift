//
//  ApiError.swift
//  TicTacToe

import Foundation

enum ApiError: Error {
    case invalidUrl
    case decodingError
    case serverError(statusCode: Int, reason: String?)
    case unauthorized
    case unknown(Error)
}
