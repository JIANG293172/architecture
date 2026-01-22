//
//  CarStatus.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

// Models/CarStatus.swift
import Foundation

struct CarStatus {
    let totalMileage: Int          // 总里程
    let remainingRange: Int        // 剩余续航
    let currentRange: Int          // 当前里程
    let batteryLevel: Int          // 电池电量
    let lockStatus: Bool           // 锁车状态
    let windowStatus: Bool         // 车窗状态
    let tirePressure: [Double]     // 轮胎压力
}

// Models/ControlFunction.swift
struct ControlFunction {
    let id: String
    let name: String
    let icon: String
    let type: FunctionType
}

enum FunctionType {
    case airConditioner
    case quickCool
    case digitalKey
    case parkingLocation
    case carSharing
    case assistedDriving
    case safetyService
    case vehicleService
    case moreService
}

// Models/Banner.swift
struct Banner {
    let id: String
    let imageUrl: String
    let title: String
    let linkUrl: String?
}
