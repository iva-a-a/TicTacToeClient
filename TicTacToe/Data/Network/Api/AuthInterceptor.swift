//
//  AuthInterceptor.swift
//  TicTacToe

import Foundation
import CoreData

struct AuthInterceptor {
    static func authHeader() -> String? {
        let context = CoreDataStack.shared.viewContext
        let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
        
        do {
            guard let user = try context.fetch(request).first,
                  let login = user.login,
                  let password = user.password,
                  !login.isEmpty,
                  !password.isEmpty
            else { return nil }
            
            let loginPassword = "\(login):\(password)"
            guard let data = loginPassword.data(using: .utf8) else { return nil }
            
            return "Basic \(data.base64EncodedString())"
        } catch {
            print("AuthInterceptor fetch error: \(error)")
            return nil
        }
    }
}
