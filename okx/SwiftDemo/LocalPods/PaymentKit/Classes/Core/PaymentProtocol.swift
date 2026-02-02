import Foundation

/// 支付渠道协议：所有具体支付渠道（支付宝、微信等）必须实现此协议
public protocol PaymentChannelProtocol {
    /// 渠道标识
    var method: PaymentMethod { get }
    
    /// 检查渠道是否可用（如是否安装了 App）
    func isAvailable() -> Bool
    
    /// 发起支付
    /// - Parameters:
    ///   - order: 订单信息
    ///   - completion: 结果回调
    func pay(order: PaymentOrder, completion: @escaping (PaymentResult) -> Void)
    
    /// 处理外部 App 跳转回来的回调（AppDelegate/SceneDelegate 调用）
    func handleOpenURL(_ url: URL) -> Bool
}

/// 默认实现
extension PaymentChannelProtocol {
    public func handleOpenURL(_ url: URL) -> Bool { return false }
}
