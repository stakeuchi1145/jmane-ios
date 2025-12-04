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
    private let baseUrl: String = "\(ProcessInfo.processInfo.environment["BASE_URL"] ?? "")"

    func login(email: String, password: String) async throws -> String {
        let url = baseUrl + "auth/login"
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200 ... 400)
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
}
