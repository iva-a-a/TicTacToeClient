//
//  NetworkClient.swift
//  TicTacToe

import Foundation
import Alamofire

final class NetworkClient {

    private let session: Session

    init(interceptor: RequestInterceptor? = nil) {
        self.session = Session(interceptor: interceptor)
    }

    func get<T: Decodable>(_ url: String) async throws -> T {
        try await request(url, method: .get, parameters: Optional<Data>.none)
    }

    func post<T: Decodable, B: Encodable>(_ url: String, body: B) async throws -> T {
        try await request(url, method: .post, parameters: body)
    }

    private func request<T: Decodable, P: Encodable>(
        _ url: String,
        method: HTTPMethod,
        parameters: P? = nil
    ) async throws -> T {
        let parseError = self.parseServerError
        return try await withCheckedThrowingContinuation { continuation in
            let request = session.request(
                url,
                method: method,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )

            request.validate().responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: ApiError.decodingError)
                    }

                case .failure:
                    let statusCode = response.response?.statusCode ?? -1
                    if statusCode == 401 {
                        continuation.resume(throwing: ApiError.unauthorized)
                    } else {
                        continuation.resume(
                            throwing: parseError(response.data, statusCode))
                    }
                }
            }
        }
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
}
