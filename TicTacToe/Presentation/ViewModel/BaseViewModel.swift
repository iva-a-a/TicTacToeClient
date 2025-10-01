//
//  BaseViewModel.swift
//  TicTacToe

import Foundation
import SwiftUI

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var alertMessage: String? = nil
    
    let errorHandler: ErrorHandlerProtocol
    
    init(errorHandler: ErrorHandlerProtocol) {
        self.errorHandler = errorHandler
    }

    func handleError(_ error: Error) async {
        let resolution = await errorHandler.handle(error)
        switch resolution {
        case .silent:
            break
        case .message(let text), .logout(let text):
            alertMessage = text
        }
    }
}

extension BaseViewModel {
    func performWithLoading(_ block: @escaping () async -> Void) {
        Task {
            isLoading = true
            defer { isLoading = false }
            await block()
        }
    }
}

extension BaseViewModel {
    func validateNotEmpty(_ value: String, fieldName: String) -> Bool {
        if value.isEmpty {
            alertMessage = "Enter your \(fieldName)"
            return false
        }
        return true
    }
}

extension BaseViewModel {
    func withCurrentUser(_ block: @escaping (UserDomain) async throws -> Void) async {
        do {
            guard let me = try await (self as? HasCurrentUserService)?.currentUserService.getCurrentUser() else {
                return
            }
            try await block(me)
        } catch {
            await handleError(error)
        }
    }
}
