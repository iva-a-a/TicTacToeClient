//
//  JwtUtil.swift
//  TicTacToe

import Foundation

public struct JwtUtil {

    private static func decodePayload(_ token: String) -> [String: Any]? {
        print(token)
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return nil }

        var base64 = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 { base64 += "=" }

        guard let data = Data(base64Encoded: base64),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let payload = jsonObject as? [String: Any] else {
            return nil
        }
        return payload
    }

    private static func expiration(from token: String) -> Date? {
        guard let payload = decodePayload(token) else { return nil }

        guard let expValue = payload["expiration"] else { return nil }

        if let expDouble = expValue as? Double {
            return Date(timeIntervalSince1970: expDouble)
        } else if let expInt = expValue as? Int {
            return Date(timeIntervalSince1970: TimeInterval(expInt))
        } else if let expNum = expValue as? NSNumber {
            return Date(timeIntervalSince1970: expNum.doubleValue)
        } else if let expString = expValue as? String, let time = Double(expString) {
            return Date(timeIntervalSince1970: time)
        }
        return nil
    }

    public static func isAccessTokenAlive(_ token: String) -> Bool {
        guard let expiry = expiration(from: token) else { return false }
        return expiry > Date()
    }

    public static func isRefreshTokenAlive(_ token: String) -> Bool {
        guard let expiry = expiration(from: token) else { return false }
        return expiry > Date()
    }
}
