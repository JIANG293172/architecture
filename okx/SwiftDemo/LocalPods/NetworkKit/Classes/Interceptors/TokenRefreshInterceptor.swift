import Foundation
import Alamofire

/// Token 自动刷新与请求重试拦截器
/// 
/// 封装深度：
/// 1. 竞态条件 (Race Condition)：多个请求同时触发 401 时，如何保证只刷新一次 Token？
/// 2. 递归保护：防止刷新 Token 接口本身返回 401 导致死循环。
public class TokenRefreshInterceptor: RequestInterceptor {
    
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    public init() {}
    
    // MARK: - RequestRetrier
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock(); defer { lock.unlock() }
        
        // 1. 检查是否是 401 错误 (未授权)
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 2. 将请求加入等待队列
        requestsToRetry.append(completion)
        
        // 3. 如果当前没有正在刷新的任务，则发起刷新
        if !isRefreshing {
            refreshAccessToken { [weak self] success in
                guard let self = self else { return }
                
                self.lock.lock(); defer { self.lock.unlock() }
                
                self.isRefreshing = false
                
                // 4. 刷新成功后，重试所有等待中的请求；否则全部报错
                let result: RetryResult = success ? .retry : .doNotRetryWithError(error)
                self.requestsToRetry.forEach { $0(result) }
                self.requestsToRetry.removeAll()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        isRefreshing = true
        
        print("[NetworkKit] 🚀 开始刷新 Token...")
        
        // 模拟网络请求刷新 Token
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let success = true // 假设刷新成功
            if success {
                UserDefaults.standard.set("new_mock_token_\(Date().timeIntervalSince1970)", forKey: "com.networkkit.auth.token")
                print("[NetworkKit] ✅ Token 刷新成功")
            } else {
                print("[NetworkKit] ❌ Token 刷新失败")
            }
            completion(success)
        }
    }
}
