//
//  ChanganCarControlHome.swift
//  SwiftUI09
//
//  Created by CQCA202121101_2 on 2026/1/8.
//

import SwiftUI

struct ChanganCarControlHome: View {
    // 对应 Flutter State 中的变量（用 @State 管理）
    private let carModel = "长安CS75 PLUS"
    private let licensePlate = "川A·88888"
    @State private var batteryPercent = 85
    @State private var mileage = 1258
    @State private var isLock = true
    @State private var isAirOn = false
    @State private var isLoading = false
    
    // 对应 Flutter 的 SnackBar（用 @State 管理弹窗）
    @State private var snackBarText: String?
    @State private var snackBarColor: Color?
    

    // 新增：控制提示栏显示/隐藏的状态
    @State private var isSnackBarShowing = false
    
    var body: some View {
            TabView {
                NavigationStack {
                    ScrollView {
                        // 原页面内容...
                    }
                    .background(Color(hex: "F5F7FA"))
                    .navigationTitle("长安车控")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // 原右上角通知按钮...
                    }
                    // 步骤2：添加自定义底部提示栏（替代原 snackBar）
                    .overlay(
                        Group {
                            if isSnackBarShowing, let text = snackBarText, let color = snackBarColor {
                                VStack {
                                    Spacer()
                                    Text(text)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(color)
                                        .cornerRadius(8)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 32) // 避开底部导航栏
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isSnackBarShowing)
                            }
                        }
                    )
                }
                .tabItem { /* 原标签配置... */ }
                .tag(0)
                
                // 其他标签页...
            }
            // 原 TabView 样式配置...
        }
    
    
}

// MARK: - 控制操作（对应原 Flutter 的 _toggleLock/_toggleAirCondition 等）
extension ChanganCarControlHome {
    // 示例：toggleLock 方法中显示提示
    private func toggleLock() async {
        guard !isLoading else { return }
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        isLock.toggle()
        isLoading = false
        
        // 显示自定义提示栏
        snackBarText = isLock ? "车辆已上锁" : "车辆已解锁"
        snackBarColor = isLock ? .green : Color(hex: "0066CC")
        isSnackBarShowing = true
        
        // 2秒后自动隐藏
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSnackBarShowing = false
        }
    }
    
    // 空调开关
    private func toggleAirCondition() async {
        guard !isLoading else { return }
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        isAirOn.toggle()
        isLoading = false
        
        snackBarText = isAirOn ? "空调已开启" : "空调已关闭"
        snackBarColor = isAirOn ? Color(hex: "F5A623") : .gray
    }
    
    // 模拟电量减少
    private func simulateBatteryConsumption() {
        guard batteryPercent > 0 else { return }
        batteryPercent -= 5
        mileage = Int(Double(mileage) * 0.95)
    }
    
    // 其他需要显示提示的地方（如 showNoNotification）也做同样修改
    private func showNoNotification() {
        snackBarText = "暂无新通知"
        snackBarColor = .gray
        isSnackBarShowing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSnackBarShowing = false
        }
    }
}

// MARK: - 常用控制区（对应原 _buildControlArea）
extension ChanganCarControlHome {
    private func buildControlArea() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("常用控制")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
            
            // 网格布局（对应 Flutter 的 GridView.count）
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 4),
                spacing: 8,
                pinnedViews: [.sectionHeaders]
            ) {
                // 锁车/解锁
                buildControlButton(
                    icon: isLock ? "lock.open.fill" : "lock.fill",
                    text: isLock ? "解锁" : "上锁",
                    color: isLock ? .gray : Color(hex: "0066CC"),
                    isLoading: isLoading
                ) {
                    Task { await toggleLock() }
                }
                
                // 空调
                buildControlButton(
                    icon: isAirOn ? "snowflake" : "snowflake.slash",
                    text: "空调",
                    color: isAirOn ? Color(hex: "F5A623") : .gray,
                    isLoading: isLoading
                ) {
                    Task { await toggleAirCondition() }
                }
                
                // 寻车
                buildControlButton(
                    icon: "location.circle",
                    text: "寻车"
                ) {
                    snackBarText = "寻车模式已开启，车辆鸣笛+双闪"
                    snackBarColor = .orange
                }
                
                // 后备箱
                buildControlButton(
                    icon: "trunk.fill",
                    text: "后备箱"
                ) {
                    snackBarText = "后备箱已开启"
                    snackBarColor = .gray
                }
                
                // 车窗
                buildControlButton(
                    icon: "window.closed",
                    text: "车窗"
                ) {
                    snackBarText = "车窗控制功能待开通"
                    snackBarColor = .gray
                }
                
                // 天窗
                buildControlButton(
                    icon: "sun.max.fill",
                    text: "天窗"
                ) {
                    snackBarText = "天窗控制功能待开通"
                    snackBarColor = .gray
                }
                
                // 充电/加油
                buildControlButton(
                    icon: batteryPercent > 0 ? "ev.charger.fill" : "fuelpump.fill",
                    text: batteryPercent > 0 ? "充电" : "加油"
                ) {
                    simulateBatteryConsumption()
                }
                
                // 更多控制
                buildControlButton(
                    icon: "ellipsis",
                    text: "更多"
                ) {
                    snackBarText = "更多控制功能即将上线"
                    snackBarColor = .gray
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
        .padding(.horizontal, 16)
    }
    
    // 单个控制按钮（对应原 _buildControlButton）
    private func buildControlButton(
        icon: String,
        text: String,
        color: Color = .gray,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 6) {
                ZStack {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(color)
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "0066CC")))
                            .frame(width: 16, height: 16)
                    }
                }
                
                Text(text)
                    .font(.system(size: 11))
                    .foregroundColor(color)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}

// MARK: - 车辆数据统计（对应原 _buildCarDataArea）
extension ChanganCarControlHome {
    private func buildCarDataArea() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("车辆数据")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
            
            // 第一行数据
            HStack(spacing: 12) {
                buildDataCard(
                    title: "今日里程",
                    value: "45.8 km",
                    icon: "map"
                )
                
                buildDataCard(
                    title: "平均电耗",
                    value: "15.2 kWh/100km",
                    icon: "car"
                )
            }
            
            // 第二行数据
            HStack(spacing: 12) {
                buildDataCard(
                    title: "累计里程",
                    value: "12580 km",
                    icon: "speedometer"
                )
                
                buildDataCard(
                    title: "本月驾驶",
                    value: "28.5 h",
                    icon: "timer"
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
        .padding(.horizontal, 16)
    }
    
    // 单个数据卡片（对应原 _buildDataCard）
    private func buildDataCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundColor(Color(hex: "0066CC"))
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "999999"))
                .padding(.top, 6)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
        }
        .padding(12)
        .background(Color(hex: "F8F9FA"))
        .cornerRadius(8)
        .border(Color(hex: "EEEEEE"), width: 1)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 功能入口区（对应原 _buildFunctionEntrance）
extension ChanganCarControlHome {
    private func buildFunctionEntrance() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("功能服务")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
            
            // 功能网格
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 4),
                spacing: 8
            ) {
                buildFunctionItem(icon: "wrench.fill", text: "维保预约")
                buildFunctionItem(icon: "parkingsign.circle.fill", text: "停车服务")
                buildFunctionItem(icon: "giftcard.fill", text: "优惠券")
                buildFunctionItem(icon: "questionmark.circle.fill", text: "客服中心")
                buildFunctionItem(icon: "gearshape.fill", text: "车辆设置")
                buildFunctionItem(icon: "doc.plaintext.fill", text: "电子手册")
                buildFunctionItem(icon: "bag.fill", text: "精品商城")
                buildFunctionItem(icon: "clock.fill", text: "行程记录")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
        .padding(.horizontal, 16)
    }
    
    // 功能入口项（对应原 _buildFunctionItem）
    private func buildFunctionItem(icon: String, text: String) -> some View {
        Button(action: {
            snackBarText = "\(text) 功能待开通"
            snackBarColor = .gray
        }) {
            VStack(alignment: .center, spacing: 6) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(Color(hex: "666666"))
                
                Text(text)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "666666"))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}

// MARK: - 底部导航栏（对应原 _buildBottomNav）
extension ChanganCarControlHome {
    private func buildBottomNav() -> some View {
        TabView {
            // 首页（当前页面）
            Text("首页")
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            // 车辆
            Text("车辆")
                .tabItem {
                    Label("车辆", systemImage: "car.fill")
                }
                .tag(1)
            
            // 行程
            Text("行程")
                .tabItem {
                    Label("行程", systemImage: "map.fill")
                }
                .tag(2)
            
            // 我的
            Text("我的")
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        // 选中颜色
        .tint(Color(hex: "0066CC"))
        // 文字大小
        .font(.system(size: 12))
        // 背景色
        .background(Color.white)
        // 阴影
        .shadow(color: Color.black.opacity(0.12), radius: 8, y: -2)
        // 修复：移除错误的 toolbarColorScheme，改用 UIKit 外观设置（更稳定）
    }
}

