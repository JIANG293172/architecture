//
//  AuthService.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/11.
//

import Foundation
import RxSwift

protocol AuthServiceType {
    func login(username: String, password: String) -> Observable<loginResponse>
    func validateUsername(_ username: String) throws ->  ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
}

struct ValidationResult {
    let isValid: Bool
    let message: String?
}

class AuthService: AuthServiceType {
    static let shared = AuthService()
    
    func login(username: String, password: String) -> Observable<loginResponse> {
        return Observable.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                let random = Int.random(in: 1...10)
                
                switch random {
                case 1...3:
                    let user = User (id: 123, username: username, email: "\(username)@example", token: "token1")
                    let response = loginResponse(user: user, message: "登录成功")
                    observer.onNext(response)
                    observer.onCompleted()
                case 4...6:
                    let error = NSError (domain: "authError", code: 401, userInfo: [NSLocalizedDescriptionKey: "用户名或则密码错误"])
                    observer.onError(error)
                case 7...8:
                    let error = NSError(domain: "AuthError", code: 423, userInfo: [NSLocalizedDescriptionKey: "账号锁定"])
                    observer.onError(error)
                default:
                    let error = NSError(domain: "networkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "网络连接失败，请检查网络设置"])
                    observer.onError(error)
                }
            }
  
            return Disposables.create()
        }
    }
    
    func validateUsername(_ username: String) throws ->  ValidationResult {
        if username.isEmpty {
            return ValidationResult(isValid: false, message: "用户名为空")
        }
        
        if username.count < 3 {
            return ValidationResult(isValid: false , message: "用户名至少三个字符")
        }
        
        if username.count > 20 {
            return ValidationResult(isValid: false, message: "用户名不能超过20个字符")
        }
        
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        
        let isValid = predicate.evaluate(with: username)
        
        return ValidationResult(isValid: isValid, message: isValid ? nil : "用户只能包含字母、数字和下划线")
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return ValidationResult(isValid: false, message: "密码不能为空")
        }
        
        if password.count < 6 {
            return ValidationResult(isValid: false, message: "密码至少6个字符")
        }
        
        if password.count > 30 {
            return ValidationResult(isValid: false, message: "密码不能超过30个字符")
        }
        
        return ValidationResult(isValid: true, message: nil)
    }
    
    
    
}
