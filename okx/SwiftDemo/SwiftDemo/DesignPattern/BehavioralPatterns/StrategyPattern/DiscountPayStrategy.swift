//
//  DiscountPayStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 折扣支付策略：具体策略实现
/// 作用：实现8折优惠的计算逻辑
/// 策略模式中的具体策略：
/// 1. 实现策略接口（PayStrategy）
/// 2. 提供具体的算法实现
class DiscountPayStrategy: PayStrategy {
    /// 计算最终支付金额
    /// 思路：将原始金额乘以0.8，实现8折优惠
    /// - Parameter original: 原始金额
    /// - Returns: 8折后的最终金额
    func calculateFinalAmount(original: Double) -> Double {
        // 8折优惠：原始金额 * 0.8
        return original * 0.8
    }
}
