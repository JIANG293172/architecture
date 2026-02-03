import Foundation
import Alamofire

/// 网络错误分类 - 封装重点：错误链路追踪与分类处理
/// 能够清晰区分：业务错误 (Server Error)、网络传输错误 (Network Error)、客户端逻辑错误 (Client Error)
public enum NetworkError: Error {
    
    // MARK: - 客户端错误 (Client-side)
    
    /// 无效的 URL
    case invalidURL
    /// 参数序列化失败
    case parameterEncodingFailed(reason: String)
    /// 无网络连接 (Reachability)
    case noNetwork
    /// 请求超时
    case timeout
    /// 取消请求
    case cancelled
    
    // MARK: - 服务端/业务错误 (Server-side)
    
    /// HTTP 状态码错误 (4xx, 5xx)
    case httpError(statusCode: Int, data: Data?)
    /// 业务逻辑错误 (例如：code != 0, msg = "密码错误")
    case businessError(code: Int, message: String, data: Any?)
    /// 数据解析失败 (JSON -> Model 失败)
    case decodingFailed(Error)
    
    // MARK: - 安全/证书错误 (Security)
    
    /// TLS 握手失败/证书校验不通过
    case sslPinningFailed
    
    /// 未知错误
    case unknown(Error?)
    
    /// 友好的错误描述，可直接给 UI 展示
    public var localizedDescription: String {
        switch self {
        case .noNetwork: return "当前无网络连接，请检查设置"
        case .timeout: return "请求超时，请稍后重试"
        case .httpError(let code, _): return "服务器异常(HTTP \(code))"
        case .businessError(_, let msg, _): return msg
        case .decodingFailed: return "数据解析异常"
        case .sslPinningFailed: return "安全连接失败(证书校验未通过)"
        default: return "请求失败，请稍后重试"
        }
    }
}
