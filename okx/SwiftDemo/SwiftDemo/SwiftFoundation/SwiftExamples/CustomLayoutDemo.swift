import SwiftUI

// MARK: - 1. Custom Layout Protocol Demo (iOS 16+)
/// 原理：
/// SwiftUI 的 Layout 协议允许我们完全控制子视图的测量 (sizeThatFits) 和 放置 (placeSubviews)。
/// 传统的 Stack (HStack/VStack) 在复杂布局（如瀑布流、环形布局）下难以实现。
///
/// 使用方式：
/// 实现两个核心方法：
/// 1. sizeThatFits: 计算容器视图在给定提议大小下的最终尺寸。
/// 2. placeSubviews: 将子视图放置在具体的坐标点上。

@available(iOS 16.0, *)
struct CircularLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // 建议尺寸或默认 300x300
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let radius = min(bounds.width, bounds.height) / 3
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        for (index, subview) in subviews.enumerated() {
            // 计算每个子视图的角度
            let angle = Angle.degrees(Double(index) / Double(subviews.count) * 360.0)
            
            // 计算子视图的 X, Y 坐标
            let x = center.x + radius * cos(CGFloat(angle.radians))
            let y = center.y + radius * sin(CGFloat(angle.radians))
            
            // 放置子视图
            subview.place(at: CGPoint(x: x, y: y), anchor: .center, proposal: .unspecified)
        }
    }
}

@available(iOS 16.0, *)
struct CustomLayoutDemo: View {
    @State private var count = 6
    
    var body: some View {
        VStack {
            Text("Circular Layout Demo")
                .font(.headline)
            
            CircularLayout {
                ForEach(0..<count, id: \.self) { i in
                    SwiftUI.Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .overlay(Text("\(i)").foregroundColor(.white))
                }
            }
            .frame(height: 400)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding()
            
            Stepper("Count: \(count)", value: $count, in: 1...1000)
                .padding()
            
            Text("Layout 协议是 iOS 16 引入的重大特性，它通过 sizeThatFits 和 placeSubviews 实现了高性能的自定义布局，避免了传统 GeometryReader 带来的二次计算开销。")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Custom Layout")
    }
}
