//
//  Order.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 订单类：策略模式的上下文（Context）
/// 作用：持有策略的引用，并在需要时调用策略的方法
/// 特点：
/// 1. 依赖于策略接口（PayStrategy），而不是具体的策略实现
/// 2. 无需修改自身代码即可切换不同的策略
/// 3. 封装了策略的使用细节，客户端只需关心策略的选择
class Order {
    /// 支付策略：通过构造函数注入
    private var payStrategy: PayStrategy
    
    /// 初始化订单
    /// - Parameter strategy: 支付策略
    init(strategy: PayStrategy) {
        self.payStrategy = strategy
    }
    
    /// 获取最终支付金额
    /// 思路：委托给当前设置的支付策略来计算最终金额
    /// - Parameter original: 原始金额
    /// - Returns: 计算后的最终金额
    func getFinalAmount(original: Double) -> Double {
        // 调用策略的calculateFinalAmount方法计算最终金额
        // 这里体现了策略模式的核心：将算法的实现委托给具体的策略
        return payStrategy.calculateFinalAmount(original: original)
    }
}
