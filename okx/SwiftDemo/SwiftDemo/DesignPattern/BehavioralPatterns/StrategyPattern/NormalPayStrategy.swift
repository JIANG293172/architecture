//
//  NormalPayStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 普通支付策略：具体策略实现
/// 作用：实现原价支付的计算逻辑（无优惠）
/// 策略模式中的具体策略：
/// 1. 实现策略接口（PayStrategy）
/// 2. 提供具体的算法实现
class NormalPayStrategy: PayStrategy {
    /// 计算最终支付金额
    /// 思路：直接返回原始金额，不做任何优惠处理
    /// - Parameter original: 原始金额
    /// - Returns: 原始金额（无优惠）
    func calculateFinalAmount(original: Double) -> Double {
        // 原价支付：直接返回原始金额
        return original
    }
}
