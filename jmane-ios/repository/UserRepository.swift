//
//  UserRepository.swift
//  jmane-ios
//
//  Created by Shin Takeuchi on 2025/12/04.
//

import Combine
import SwiftUI

class UserRepository: ObservableObject {
    static let shared = UserRepository()
    
    @ObservedObject var apiService = ApiService.shared
    
    func login(email: String, password: String) async throws -> String {
        return try await apiService.login(email: email, password: password)
    }
}
