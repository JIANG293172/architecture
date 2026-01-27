//
//  PayStrategy.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

/// 策略协议
protocol PayStrategy {
    func calculateFinalAmount(original: Double) -> Double
}
