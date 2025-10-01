//
//  NetworkClient.swift
//  TicTacToe

import Foundation
import Alamofire

final class NetworkClient {

    static let shared = NetworkClient()
    private let session: Session
    
    private init() {
        let interceptor = AuthRequestInterceptor()
        session = Session(interceptor: interceptor)
    }
    
    private func parseServerError(data: Data?, statusCode: Int) -> ApiError {
        guard let data = data else {
            return .serverError(statusCode: statusCode, reason: nil)
        }
        
        if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data),
           serverError.error {
            return .serverError(statusCode: statusCode, reason: serverError.reason)
        } else {
            return .decodingError
        }
    }
    
    func get<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: Endpoints.baseURL + path) else {
            throw ApiError.invalidUrl
        }
        
        let parseError = self.parseServerError
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure:
                        let code = response.response?.statusCode ?? 0
                        if code == 401 {
                            continuation.resume(throwing: ApiError.unauthorized)
                        } else {
                            continuation.resume(throwing: parseError(response.data, code))
                        }
                    }
                }
        }
    }
    
    func post<T: Decodable, U: Encodable>(_ path: String, body: U) async throws -> T {
        guard let url = URL(string: Endpoints.baseURL + path) else {
            throw ApiError.invalidUrl
        }
        
        let parseError = self.parseServerError
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure:
                        let code = response.response?.statusCode ?? 0
                        if code == 401 {
                            continuation.resume(throwing: ApiError.unauthorized)
                        } else {
                            continuation.resume(throwing: parseError(response.data, code))
                        }
                    }
                }
        }
    }
}
