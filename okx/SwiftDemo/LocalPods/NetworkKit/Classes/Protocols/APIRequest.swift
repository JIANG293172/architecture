import Foundation
import Alamofire

/// RESTful API 请求协议
/// 
/// 封装重点：为什么使用协议而不是类？
/// 1. 解耦：业务层只需要定义符合协议的对象，不依赖具体的网络实现。
/// 2. 灵活性：可以针对不同环境（Dev/Prod）通过扩展轻松切换 BaseURL。
/// 3. 面向协议编程 (POP)：Swift 的核心设计思想。
///
/// 面向协议编程 (Protocol-Oriented Programming, POP)
//- 应用 : APIRequest.swift
//- 面试点 : “为什么用协议而不是基类？”
//  - 回答 : 协议比基类更轻量、更灵活。业务方只需让 Struct 或 Enum 遵循 APIRequest ，无需继承沉重的基类。通过 协议扩展 (Protocol Extension) ，我们为 baseURL 、 timeout 等提供了默认实现，实现了“按需重写”，这体现了 Swift 的核心设计思想。

public protocol APIRequest {
    /// 返回的模型类型
    associatedtype ResponseDataType: Decodable
    
    /// 基础路径 (如: https://api.example.com)
    var baseURL: String { get }
    
    /// 具体路径 (如: /v1/user/profile)
    var path: String { get }
    
    /// HTTP 方法 (GET, POST, PUT, DELETE 等)
    var method: HTTPMethod { get }
    
    /// 请求参数
    var parameters: [String: Any]? { get }
    
    /// 参数编码方式 (JSONEncoding, URLEncoding)
    var encoding: ParameterEncoding { get }
    
    /// 自定义 Header
    var headers: HTTPHeaders? { get }
    
    /// 是否需要 Token 认证 (拦截器根据此字段判断是否注入 Token)
    var requiresAuth: Bool { get }
    
    /// 请求超时时间
    var timeout: TimeInterval { get }
}

// MARK: - 默认实现 (Default Implementation)

//策略模式 (Strategy Pattern)
//- 应用 : 在 APIRequest 中定义 encoding 和 method 。
//- 面试点 : “如何处理不同的请求编码？”
//  - 回答 : 每个具体的 Request 对象决定自己的参数编码策略（JSON 或 URL 编码）， NetworkClient 根据协议定义的策略进行执行，体现了 对扩展开放，对修改关闭 (OCP) 。


public extension APIRequest {
    
    var baseURL: String {
        return "https://api.github.com" // 示例默认值
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var requiresAuth: Bool {
        return true
    }
    
    var timeout: TimeInterval {
        return 30.0
    }
}
