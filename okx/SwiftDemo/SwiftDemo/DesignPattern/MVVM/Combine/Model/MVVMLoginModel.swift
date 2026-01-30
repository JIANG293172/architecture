import Foundation

/// 登录用户模型
struct MVVMLoginUser: Codable {
    let id: String
    let username: String
    let token: String
    let lastLogin: Date
}

/// 登录响应结果
enum LoginResult {
    case success(MVVMLoginUser)
    case failure(LoginError)
}

/// 登录错误类型
enum LoginError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case serverError
    case userLocked
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "用户名或密码错误"
        case .networkError: return "网络连接异常"
        case .serverError: return "服务器响应异常"
        case .userLocked: return "账号已被锁定"
        }
    }
}
