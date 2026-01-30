//
//  PaymentFacade.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 支付外观类，提供统一的支付接口
class PaymentFacade {
    private let alipay = AlipaySDK()
    private let wechat = WeChatPaySDK()
    
    /// 统一支付方法（隐藏内部步骤）
    /// - Parameters:
    ///   - amount: 支付金额
    ///   - type: 支付类型（alipay 或 wechat）
    func pay(amount: Double, type: String) {
        switch type {
        case "alipay":
            alipay.preparePayment(amount: amount)
            alipay.submitPayment()
        case "wechat":
            wechat.configPayment(amount: amount)
            wechat.sendPaymentRequest()
        default:
            break
        }
    }
}
