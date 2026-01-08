//
//  AutoHomePageStateView.swift
//  SwiftUI09
//
//  Created by CQCA202121101_2 on 2026/1/8.
//

import SwiftUI

struct AutoHomePageStateView: View {
    // 对应 Flutter 的 final 参数（SwiftUI 中直接用 let）
    let licensePlate: String
    let carModel: String
    let batteryPercent: Int
    let mileage: Int
    let isLock: Bool
    let isLoading: Bool
    
    var body: some View {
        VStack {
            buildCarInfoCard()
        }
        .frame(height: 220)
        .padding(.horizontal, 8)
        .background(Color.blue.opacity(0.1))
    }
    
    // 对应原 _buildCarInfoCard
    private func buildCarInfoCard() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // 车辆型号 + 车牌
            HStack {
                Text(carModel)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(licensePlate)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
            }
            
            // 电量 + 剩余里程 + 状态
            HStack(alignment: .center, spacing: 24) {
                // 电量模块
                VStack(spacing: 8) {
                    ZStack {
                        // 电池图标（对应 Flutter 的 Icons.battery_full）
                        Image(systemName: batteryPercent > 20 ? "battery.100" : "battery.0")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        
                        // 加载中进度圈
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                    Text("\(batteryPercent)%")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                
                // 剩余里程
                VStack(alignment: .leading, spacing: 4) {
                    Text("剩余里程")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(mileage) km")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // 车辆状态标签
                HStack(spacing: 4) {
                    Image(systemName: isLock ? "lock.fill" : "lock.open.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.white)
                    
                    Text(isLock ? "车辆已上锁" : "车辆未上锁")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.24))
                .cornerRadius(20)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color(hex: "0066CC"), Color(hex: "0088EE")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// 辅助：Hex 颜色转换（对应 Flutter 的 Color(0xFF0066CC)）
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
