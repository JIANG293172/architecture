import Foundation

/// 微信支付渠道实现
public final class WeChatPayChannel: PaymentChannelProtocol {
    public let method: PaymentMethod = .weChatPay
    
    public init() {}
    
    public func isAvailable() -> Bool {
        // 实际开发中：return WXApi.isWXAppInstalled()
        return true
    }
    
    public func pay(order: PaymentOrder, completion: @escaping (PaymentResult) -> Void) {
        print("🚀 [WeChatPay] 正在调用微信 SDK...")
        
        /* 
         封装话术：
         1. 构造 PayReq 对象，填充 partnerId, prepayId, nonceStr, timeStamp, sign 等参数。
         2. 调用 WXApi.send(req) 发起跳转。
         3. 结果在 onResp 回调中处理。
        */
        
        // 模拟支付成功
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(orderId: order.orderId))
        }
    }
    
    public func handleOpenURL(_ url: URL) -> Bool {
        // 实际开发中：return WXApi.handleOpen(url, delegate: self)
        return url.absoluteString.contains("pay")
    }
}
