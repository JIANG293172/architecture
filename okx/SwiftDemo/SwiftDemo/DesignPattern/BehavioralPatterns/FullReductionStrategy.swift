//
//  FullReductionStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 具体策略：满减
class FullReductionStrategy: PayStrategy {
    func calculateFinalAmount(original: Double) -> Double {
        return original >= 100 ? original - 20 : original
    }
}
