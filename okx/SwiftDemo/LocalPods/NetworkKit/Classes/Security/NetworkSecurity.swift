import Foundation
import Security
import Alamofire

/// 网络安全模块 - TLS 双向认证与证书固定 (SSL Pinning)
/// 
/// 封装重点：
/// 1. 什么是双向认证 (Mutual TLS)？
///    不仅客户端验证服务器身份，服务器也验证客户端身份。
/// 2. 为什么需要证书固定 (Pinning)？
///    防止中间人攻击 (MITM)，即使系统根证书库被劫持。
public class NetworkSecurity {
    
    public static let shared = NetworkSecurity()
    
    private init() {}
    
    /// 获取 ServerTrustManager 用于单向/双向校验
    /// - Parameter pinningMode: 固定模式 (.certificate 或 .publicKeys)
    public func createServerTrustManager(pinningMode: PinningMode = .certificate) -> ServerTrustManager {
        // 这里假设我们有一组受信任的证书文件在 Bundle 中
        // 封装点：在真实项目中，证书通常放在加密的路径或通过代码注入
        let evaluators: [String: ServerTrustEvaluating] = [
            "api.github.com": PinnedCertificatesTrustEvaluator(), // 证书固定
            "your-secure-server.com": PublicKeysTrustEvaluator()   // 公钥固定
        ]
        
        return ServerTrustManager(evaluators: evaluators)
    }
    
    /// 获取客户端证书 (用于双向认证)
    /// - Returns: URLCredential 包含客户端证书和私钥
    public func getClientCredential() -> URLCredential? {
        // 1. 寻找本地的 .p12 证书文件
        guard let p12Path = Bundle.main.path(forResource: "client_cert", ofType: "p12"),
              let p12Data = try? Data(contentsOf: URL(fileURLWithPath: p12Path)) else {
            return nil
        }
        
        // 2. 证书密码 (实际项目中应从安全加固的 KeyChain 获取)
        let password = "your_cert_password"
        
        // 3. 解析 P12 导出身份标识 (Identity) 和证书链
        let options: [String: Any] = [kSecImportExportPassphrase as String: password]
        var rawItems: CFArray?
        
        let status = SecPKCS12Import(p12Data as CFData, options as CFDictionary, &rawItems)
        
        guard status == errSecSuccess,
              let items = rawItems as? [[String: Any]],
              let firstItem = items.first,
              let identity = firstItem[kSecImportItemIdentity as String] as! SecIdentity? else {
            return nil
        }
        
        // 4. 构建 URLCredential
        return URLCredential(identity: identity, certificates: nil, persistence: .forSession)
    }
}

/// 证书固定模式
public enum PinningMode {
    case certificate
    case publicKeys
}
