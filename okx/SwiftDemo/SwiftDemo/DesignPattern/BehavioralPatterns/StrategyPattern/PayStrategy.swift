//
//  PayStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 支付策略协议：策略模式的核心接口
/// 策略模式的关键组成部分：
/// 1. 策略接口（PayStrategy）：定义所有具体策略必须实现的方法
/// 2. 具体策略（NormalPayStrategy、DiscountPayStrategy、FullReductionStrategy）：实现策略接口的具体算法
/// 3. 上下文（Order）：使用策略的对象，持有策略的引用
/// 4. 客户端（StrategyPatternViewController）：创建具体策略并传递给上下文
protocol PayStrategy {
    /// 计算最终支付金额
    /// - Parameter original: 原始金额
    /// - Returns: 计算后的最终金额
    func calculateFinalAmount(original: Double) -> Double
}
