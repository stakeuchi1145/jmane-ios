//
//  LoginViewModel.swift
//  jmane-ios
//
//  Created by Shin Takeuchi on 2025/12/04.
//

import Combine
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    static let shared = LoginViewModel()

    @ObservedObject var userRepository = UserRepository.shared
    @Published var email: String = ""
    @Published var password: String = ""
    
    func validEmail() -> Bool {
        return !email.isEmpty
    }
    
    func validPassword() -> Bool {
        return !password.isEmpty
    }

    func login() async -> Bool {
        do {
            let token = try await userRepository.login(email: email, password: password)
            debugPrint("token: \(token)")
            return !token.isEmpty
        } catch {
            debugPrint(error)
            return false
        }
    }
}
