//
//  Models.swift
//  CombineLoginDemo
//

import Foundation
import Combine

struct ValidationResult {
    let isValid: Bool
    let message: String?
}

struct User {
    let username: String
    let email: String
}

struct LoginResponse {
    let user: User
    let token: String
}

protocol AuthServiceType {
    func validateUsername(_ username: String) throws -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error>
}

class AuthService: AuthServiceType {
    static let shared = AuthService()
    
    func validateUsername(_ username: String) throws -> ValidationResult {
        if username.isEmpty {
            return ValidationResult(isValid: false, message: "用户名不能为空")
        }
        if username.count < 3 {
            return ValidationResult(isValid: false, message: "用户名至少3个字符")
        }
        return ValidationResult(isValid: true, message: nil)
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return ValidationResult(isValid: false, message: "密码不能为空")
        }
        if password.count < 6 {
            return ValidationResult(isValid: false, message: "密码至少6个字符")
        }
        return ValidationResult(isValid: true, message: nil)
    }
    
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        return Deferred {
            Future<LoginResponse, Error> { promise in
                // 模拟网络请求
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                    if username == "admin" && password == "password" {
                        let user = User(username: username, email: "\(username)@example.com")
                        let response = LoginResponse(user: user, token: "fake_jwt_token")
                        promise(.success(response))
                    } else {
                        promise(.failure(NSError(domain: "LoginError", code: 401, userInfo: [NSLocalizedDescriptionKey: "用户名或密码错误"])))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
