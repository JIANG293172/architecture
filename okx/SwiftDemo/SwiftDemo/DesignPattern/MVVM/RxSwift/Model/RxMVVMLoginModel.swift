import Foundation

/// RxSwift 版本的登录用户模型 (复用结构)
struct RxMVVMLoginUser: Codable {
    let id: String
    let username: String
    let token: String
    let lastLogin: Date
}

/// 登录错误类型
enum RxLoginError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "RxSwift: 用户名或密码错误"
        case .networkError: return "RxSwift: 网络连接异常"
        case .serverError: return "RxSwift: 服务器响应异常"
        }
    }
}
