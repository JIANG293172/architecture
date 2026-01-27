//
//  NormalPayStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 具体策略：原价
class NormalPayStrategy: PayStrategy {
    func calculateFinalAmount(original: Double) -> Double {
        return original
    }
}
