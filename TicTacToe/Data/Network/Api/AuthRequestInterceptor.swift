//
//  AuthRequestInterceptor.swift
//  TicTacToe

import Alamofire
import Foundation

final class AuthRequestInterceptor: RequestInterceptor, @unchecked Sendable {

    private let tokenRepository: TokenRepositoryProtocol
    private let apiServiceProvider: () -> ApiServiceProtocol
    private let refreshState = RefreshStateActor()

    init(
        tokenRepository: TokenRepositoryProtocol,
        apiServiceProvider: @escaping () -> ApiServiceProtocol
    ) {
        self.tokenRepository = tokenRepository
        self.apiServiceProvider = apiServiceProvider
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        if let authHeader = AuthInterceptor.authHeader(tokenRepository: tokenRepository) {
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        Task {
            await refreshState.addRetryRequest(completion)

            if await refreshState.isRefreshing {
                return
            }

            await refreshState.setRefreshing(true)

            do {
                try await refreshTokensIfNeeded()
                await refreshState.finishAll(success: true)
            } catch {
                await refreshState.finishAll(success: false, error: error)
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
            }
        }
    }

    private func refreshTokensIfNeeded() async throws {
        guard
            let accessToken = tokenRepository.accessToken,
            let refreshToken = tokenRepository.refreshToken
        else {
            throw TokenError.missingTokens
        }

        let isAccessAlive = JwtUtil.isAccessTokenAlive(accessToken)
        let isRefreshAlive = JwtUtil.isRefreshTokenAlive(refreshToken)
        
        guard isRefreshAlive else {
            throw TokenError.missingTokens
        }

        if !isAccessAlive {
            let dto = try await apiServiceProvider().refreshAccessToken(
                request: RefreshJwtRequestDto(refreshToken: refreshToken)
            )
            try await tokenRepository.save(token: TokenMapper.toModel(dto))
            return
        }
    }
}

enum TokenError: Error {
    case missingTokens
}

extension Notification.Name {
    static let sessionExpired = Notification.Name("sessionExpired")
}
