import Foundation
import Alamofire

/// 网络状态监听器
public class NetworkReachability {
    
    public static let shared = NetworkReachability()
    
    private let manager = NetworkReachabilityManager()
    
    /// 网络状态回调
    public var statusChangedHandler: ((NetworkReachabilityManager.NetworkReachabilityStatus) -> Void)?
    
    private init() {}
    
    /// 开始监听
    public func startListening() {
        manager?.startListening { [weak self] status in
            print("[NetworkKit] 🌐 网络状态变更: \(status)")
            self?.statusChangedHandler?(status)
            
            // 发送通知给业务层
            NotificationCenter.default.post(
                name: .NetworkStatusDidChange,
                object: nil,
                userInfo: ["status": status]
            )
        }
    }
    
    /// 停止监听
    public func stopListening() {
        manager?.stopListening()
    }
    
    /// 当前是否有网
    public var isReachable: Bool {
        return manager?.isReachable ?? false
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    public static let NetworkStatusDidChange = Notification.Name("com.networkkit.reachability.changed")
}
