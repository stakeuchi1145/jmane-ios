//
//  ApiService.swift
//  jmane-ios
//
//  Created by Shin Takeuchi on 2025/12/04.
//

import Combine
import SwiftUI
import Alamofire

class ApiService: ObservableObject {
    static let shared = ApiService()
    private let env = ProcessInfo.processInfo.environment

    private func baseURLString() throws -> String {
        guard let value = env["BASE_API_URL"],
              !value.isEmpty else {
            throw fatalError()
        }
                
        return value
    }

    func login(email: String, password: String) async throws -> String {
        let baseUrl = try getBaseURL()
        let url = "\(baseUrl)/auth/login"

        let parameters: Parameters = [
            "email": email,
            "password": password
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    do {
                        switch response.result {
                        case .success(let data):
                            debugPrint(response)
                            let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                            continuation.resume(returning: decoded.token)
                        case .failure(let error):
                            debugPrint(error)
                            continuation.resume(throwing: error)
                        }
                    } catch {
                        debugPrint(error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    private func getBaseURL() throws -> String {
        do {
            return try baseURLString()
        } catch {
            debugPrint(error)
            throw error
        }
    }
}
