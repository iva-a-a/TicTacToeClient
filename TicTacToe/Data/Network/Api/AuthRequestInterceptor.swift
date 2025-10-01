//
//  AuthRequestInterceptor.swift
//  TicTacToe

import Foundation
import Alamofire

final class AuthRequestInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        if let auth = AuthInterceptor.authHeader() {
            request.setValue(auth, forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
