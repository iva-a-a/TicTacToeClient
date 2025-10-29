//
//  TokenRepository.swift
//  TicTacToe

import Foundation
import Security

final class TokenRepository: TokenRepositoryProtocol {
    static let shared = TokenRepository()
    private init() {}

    private let accessTokenKey = "ACCESS_TOKEN"
    private let refreshTokenKey = "REFRESH_TOKEN"

    var accessToken: String? { readFromKeychain(key: accessTokenKey) }
    var refreshToken: String? { readFromKeychain(key: refreshTokenKey) }

    @MainActor
    func save(token: TokenModel) async throws {
        saveToKeychain(key: accessTokenKey, value: token.accessToken)
        saveToKeychain(key: refreshTokenKey, value: token.refreshToken)
    }
    
    @MainActor
    func clear() async throws {
        deleteFromKeychain(key: accessTokenKey)
        deleteFromKeychain(key: refreshTokenKey)
    }

    private func saveToKeychain(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    private func readFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)
        if status == errSecSuccess,
           let data = dataRef as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        return nil
    }

    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
