//
//  WeChatPaySDK.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 微信支付SDK类，模拟复杂子系统
class WeChatPaySDK {
    /// 配置支付
    /// - Parameter amount: 支付金额
    func configPayment(amount: Double) {
        print("WeChat prepare: \(amount)")
    }
    
    /// 发送支付请求
    func sendPaymentRequest() {
        print("WeChat submit")
    }
}
