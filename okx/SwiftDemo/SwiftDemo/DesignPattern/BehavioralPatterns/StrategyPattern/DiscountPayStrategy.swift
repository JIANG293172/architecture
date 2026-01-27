//
//  DiscountPayStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 具体策略：8折
class DiscountPayStrategy: PayStrategy {
    func calculateFinalAmount(original: Double) -> Double {
        return original * 0.8
    }
}
