//
//  RefreshStateActor.swift
//  TicTacToe

import Alamofire
import Foundation

actor RefreshStateActor {
    private var _isRefreshing = false
    private var pending: [(RetryResult) -> Void] = []

    var isRefreshing: Bool { _isRefreshing }

    func addRetryRequest(_ completion: @escaping (RetryResult) -> Void) {
        pending.append(completion)
    }

    func setRefreshing(_ refreshing: Bool) {
        _isRefreshing = refreshing
    }

    func finishAll(success: Bool, error: Error? = nil) {
        let completions = pending
        pending.removeAll()
        _isRefreshing = false

        for completion in completions {
            if success {
                completion(.retry)
            } else {
                completion(.doNotRetryWithError(error ?? TokenError.missingTokens))
            }
        }
    }
}
