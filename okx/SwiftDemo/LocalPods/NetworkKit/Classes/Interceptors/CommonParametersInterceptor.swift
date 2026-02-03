import Foundation
import Alamofire

/// 公共参数/Header 拦截器
/// 封装重点：拦截器模式 (Interceptor Pattern) 的优势
/// 1. 职责单一：专门负责参数注入，不影响核心请求逻辑。
/// 2. 易于维护：所有公共逻辑收拢在一个地方。
///
///
///// 拦截器模式 (Interceptor Pattern / Chain of Responsibility)
//- 应用 : CommonParametersInterceptor.swift 和 TokenRefreshInterceptor.swift
//- 点 : “如何优雅地处理 Token 过期重试？”
//  - 回答 : 采用拦截器链设计。 RequestInterceptor 包含 Adapt （修改请求）和 Retry （错误重试）。
//  - 深度 : 特别是 TokenRefreshInterceptor 处理了 竞态条件 (Race Condition) 。当多个请求同时返回 401 时，我们通过 NSLock 和 isRefreshing 状态位，确保只发起一次刷新 Token 请求，并将其他请求加入等待队列，待刷新成功后统一重试。

public class CommonParametersInterceptor: RequestInterceptor {
    
    public init() {}
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        // 1. 注入公共 Header (例如：AppVersion, DeviceID, Platform)
        urlRequest.setValue("iOS", forHTTPHeaderField: "X-Platform")
        urlRequest.setValue(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0", forHTTPHeaderField: "X-App-Version")
        urlRequest.setValue(UUID().uuidString, forHTTPHeaderField: "X-Device-ID")
        
        // 2. 注入 Token (如果需要)
        // 注意：这里只是演示，复杂的 Token 逻辑通常在 AuthInterceptor 中处理
        if let token = UserDefaults.standard.string(forKey: "com.networkkit.auth.token") {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(urlRequest))
    }
}
