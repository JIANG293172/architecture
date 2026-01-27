//
//  FullReductionStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 满减支付策略：具体策略实现
/// 作用：实现满100减20的优惠计算逻辑
/// 策略模式中的具体策略：
/// 1. 实现策略接口（PayStrategy）
/// 2. 提供具体的算法实现
class FullReductionStrategy: PayStrategy {
    /// 计算最终支付金额
    /// 思路：如果原始金额大于等于100，则减去20元；否则保持原始金额不变
    /// - Parameter original: 原始金额
    /// - Returns: 满减后的最终金额
    func calculateFinalAmount(original: Double) -> Double {
        // 满100减20：如果原始金额 >= 100，返回 original - 20；否则返回 original
        return original >= 100 ? original - 20 : original
    }
}
