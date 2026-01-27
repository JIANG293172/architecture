//
//  Order.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 客户端：依赖策略协议，无需修改代码即可切换算法
class Order {
    private var payStrategy: PayStrategy
    init(strategy: PayStrategy) {
        self.payStrategy = strategy
    }
    func getFinalAmount(original: Double) -> Double {
        return payStrategy.calculateFinalAmount(original: original)
    }
}
