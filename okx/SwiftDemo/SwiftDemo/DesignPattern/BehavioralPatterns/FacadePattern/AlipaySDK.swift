//
//  AlipaySDK.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 支付宝SDK类，模拟复杂子系统
class AlipaySDK {
    /// 准备支付
    /// - Parameter amount: 支付金额
    func preparePayment(amount: Double) {
        print("Alipay prepare: \(amount)")
    }
    
    /// 提交支付
    func submitPayment() {
        print("Alipay submit")
    }
}
