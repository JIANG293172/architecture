import Foundation

struct RxMVVMLoginUser: Codable {
    let id: String
    let username: String
    let token: String
    let lastLogin: Date
}

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

enum RxRegisterError: Error, LocalizedError {
    case usernameTaken
    case weakPassword
    case passwordMismatch
    case networkError
    case serverError

    var errorDescription: String? {
        switch self {
        case .usernameTaken: return "RxSwift: 用户名已存在"
        case .weakPassword: return "RxSwift: 密码强度不足（至少6位）"
        case .passwordMismatch: return "RxSwift: 两次输入的密码不一致"
        case .networkError: return "RxSwift: 网络连接异常"
        case .serverError: return "RxSwift: 服务器响应异常"
        }
    }
}

struct RxRegisterRequest {
    let username: String
    let password: String
}

struct RxLoginRequest {
    let username: String
    let password: String
}

protocol RxAuthServicing {
    func login(_ request: RxLoginRequest) async throws -> RxMVVMLoginUser
    func register(_ request: RxRegisterRequest) async throws
}

final class RxMockAuthService: RxAuthServicing {
    private var userStore: [String: String]
    private let delayNanoseconds: UInt64

    init(
        userStore: [String: String] = ["admin": "123456"],
        delayNanoseconds: UInt64 = 900_000_000
    ) {
        self.userStore = userStore
        self.delayNanoseconds = delayNanoseconds
    }

    func login(_ request: RxLoginRequest) async throws -> RxMVVMLoginUser {
        try await Task.sleep(nanoseconds: delayNanoseconds)

        guard let password = userStore[request.username], password == request.password else {
            throw RxLoginError.invalidCredentials
        }

        return RxMVVMLoginUser(
            id: UUID().uuidString,
            username: request.username,
            token: "rx_token_" + UUID().uuidString,
            lastLogin: Date()
        )
    }

    func register(_ request: RxRegisterRequest) async throws {
        try await Task.sleep(nanoseconds: delayNanoseconds)

        guard request.password.count >= 6 else { throw RxRegisterError.weakPassword }
        guard userStore[request.username] == nil else { throw RxRegisterError.usernameTaken }

        userStore[request.username] = request.password
    }
}
