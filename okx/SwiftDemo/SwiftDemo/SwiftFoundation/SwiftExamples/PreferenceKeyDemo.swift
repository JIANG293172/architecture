import SwiftUI

// MARK: - 3. PreferenceKey Demo
/// 原理：
/// PreferenceKey 是 SwiftUI 中“向上通信”的机制。
/// 在 SwiftUI 中，数据通常通过 Binding 或 Environment 向下传递。
/// 但有时子视图需要告诉父视图某些信息（例如子视图的大小、滚动位置等），这时就需要 PreferenceKey。
///
/// 使用方式：
/// 1. 定义一个遵循 PreferenceKey 协议的 struct，实现 defaultValue 和 reduce 方法。
/// 2. 子视图使用 .preference(key: MyKey.self, value: someValue) 设置数据。
/// 3. 父视图使用 .onPreferenceChange(MyKey.self) { value in ... } 监听数据变化。

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PreferenceKeyDemo: View {
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            // 背景渐变随滚动变化
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .opacity(Double(min(abs(scrollOffset) / 200.0, 1.0)))
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // 一个隐藏的几何监听器
                    GeometryReader { geo in
                        Color.clear.preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 0)
                    
                    ForEach(0..<20) { i in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.8))
                            .frame(height: 100)
                            .overlay(Text("Item \(i)").font(.headline))
                            .padding(.horizontal)
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                // 更新状态触发 UI 刷新
                scrollOffset = value
            }
            
            // 悬浮显示的 Offset
            Text("Scroll Offset: \(Int(scrollOffset))")
                .padding()
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.top, 50)
        }
        .navigationTitle("Preference Key")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 面试要点：PreferenceKey 解决了 SwiftUI 视图树中子节点向父节点传递信息的问题。常见用途包括自定义导航栏标题渐变、滚动视差效果、以及自动计算多个子视图中的最大宽度。
