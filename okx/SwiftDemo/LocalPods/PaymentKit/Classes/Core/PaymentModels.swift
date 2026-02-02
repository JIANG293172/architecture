import Foundation

/// 支付方式枚举
public enum PaymentMethod: String {
    case aliPay     = "AliPay"
    case weChatPay  = "WeChatPay"
    case applePay   = "ApplePay"
    case creditCard = "CreditCard"
}

/// 支付订单信息模型
public struct PaymentOrder {
    public let orderId: String
    public let amount: Double
    public let currency: String
    public let title: String
    public let payToken: String? // 从后端获取的支付串（如支付宝的 orderString）
    
    public init(orderId: String, amount: Double, currency: String = "CNY", title: String, payToken: String? = nil) {
        self.orderId = orderId
        self.amount = amount
        self.currency = currency
        self.title = title
        self.payToken = payToken
    }
}


/// 支付结果枚举
public enum PaymentResult {
    case success(orderId: String)
    case failure(error: PaymentError)
    case userCancelled
}

/// 支付错误类型
public enum PaymentError: Error {
    case channelNotSupported    // 渠道不支持
    case channelNotInstalled    // 未安装客户端（如微信）
    case invalidOrder           // 订单信息无效
    case networkError           // 网络错误
    case sdkError(code: Int, msg: String) // 第三方 SDK 返回的错误
    case unknown
    
    public var localizedDescription: String {
        switch self {
        case .channelNotSupported: return "支付渠道不支持"
        case .channelNotInstalled: return "未安装相关支付客户端"
        case .invalidOrder: return "订单信息有误"
        case .sdkError(_, let msg): return msg
        default: return "支付失败，请稍后重试"
        }
    }
}
