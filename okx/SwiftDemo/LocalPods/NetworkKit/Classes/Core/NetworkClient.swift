import Foundation
import Alamofire

/// 核心网络客户端 - 高性能网络框架入口
/// 
/// 封装重点：
/// 1. 单例 vs 实例：通常使用单例管理全局 Session，但支持自定义配置以实现业务隔离。
/// 2. 泛型请求：支持任意符合 Decodable 协议的模型解析。
/// 3. 生命周期管理：Session 的生命周期应与 App 一致，避免重复创建销毁。
///
/// 外观模式 (Facade Pattern)
//- 应用 : NetworkClient.swift
//- 点 : “如何收敛调用入口？”
//  - 回答 : NetworkClient 是整个组件的唯一入口。它封装了底层 Alamofire Session 的配置、拦截器链的组装以及安全策略的注入。业务层不需要知道底层是用 Alamofire 还是原生 URLSession，实现了 实现细节的隐藏 。
//

public class NetworkClient {
    
    public static let shared = NetworkClient()
    
    private let session: Session
    
    private init() {
        // 1. 配置拦截器链 (Interceptor Chain)
        let interceptor = Interceptor(interceptors: [
            CommonParametersInterceptor(),
            TokenRefreshInterceptor()
        ])
        
        // 2. 配置安全校验 (TLS)
        let serverTrustManager = NetworkSecurity.shared.createServerTrustManager()
        
        // 3. 配置 Session
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        
        self.session = Session(
            configuration: configuration,
            interceptor: interceptor,
            serverTrustManager: serverTrustManager
        )
    }
    
    /// 发起请求
    /// - Parameters:
    ///   - request: 遵循 APIRequest 协议的对象
    ///   - completion: 结果回调
    /// - Returns: DataRequest (可用于取消请求)
    @discardableResult
    public func request<T: APIRequest>(_ request: T, completion: @escaping (Result<T.ResponseDataType, NetworkError>) -> Void) -> DataRequest {
        
        let url = request.baseURL + request.path
        
        return session.request(
            url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.headers
        )
        .validate() // 自动验证 200..<300 状态码
        .responseDecodable(of: T.ResponseDataType.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
                
            case .failure(let error):
                let networkError = self.mapError(error, response: response)
                completion(.failure(networkError))
            }
        }
    }
    
    // MARK: - Error Mapping
    
    /// 错误映射：将 Alamofire 错误转换为业务定义的 NetworkError
    private func mapError(_ error: AFError, response: DataResponse<some Any, AFError>) -> NetworkError {
        if let statusCode = response.response?.statusCode {
            return .httpError(statusCode: statusCode, data: response.data)
        }
        
        if error.isSessionTaskError {
            let nsError = error.underlyingError as NSError?
            if nsError?.code == NSURLErrorNotConnectedToInternet {
                return .noNetwork
            }
            if nsError?.code == NSURLErrorTimedOut {
                return .timeout
            }
        }
        
        if error.isResponseSerializationError {
            return .decodingFailed(error)
        }
        
        return .unknown(error)
    }
}
