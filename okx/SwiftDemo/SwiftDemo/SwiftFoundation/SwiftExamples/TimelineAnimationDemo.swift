import SwiftUI

// MARK: - 4. TimelineView & Canvas Demo (iOS 15+)
/// 原理：
/// TimelineView 是一个根据时间轴触发重绘的容器。它可以以极高的频率（如每帧）刷新内容。
/// Canvas 是一个高性能的 2D 即时模式绘图 API，类似于 HTML5 的 Canvas。
/// 两者结合可以实现复杂的粒子系统、波浪动画等，而不会导致视图层级爆炸。
///
/// 使用方式：
/// 1. 使用 TimelineView(.animation) 定义刷新频率。
/// 2. 在闭包内使用 Canvas 绘制图形，利用 context.draw 和 context.fill。
/// 3. 使用 date 参数计算每一帧的状态。

struct TimelineAnimationDemo: View {
    var body: some View {
        VStack {
            Text("Canvas Particle Animation")
                .font(.headline)
            
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let particleCount = 50
                    
                    for i in 0..<particleCount {
                        // 利用 sin/cos 创建动态圆周运动
                        let angle = Double(i) * (2.0 * .pi / Double(particleCount))
                        let radius = 80.0 + 30.0 * sin(time + Double(i))
                        
                        let x = size.width / 2 + CGFloat(cos(angle + time)) * CGFloat(radius)
                        let y = size.height / 2 + CGFloat(sin(angle + time)) * CGFloat(radius)
                        
                        let particleSize = 8.0 + 4.0 * sin(time * 2 + Double(i))
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: particleSize, height: particleSize)),
                            with: .color(Color(hue: Double(i) / Double(particleCount), saturation: 0.8, brightness: 1.0))
                        )
                    }
                }
            }
            .frame(height: 400)
            .background(Color.black)
            .cornerRadius(16)
            .padding()
            
            Spacer()
            
            Text("面试要点：对于需要高频更新的 UI（如示波器、复杂动效），应优先使用 Canvas 而不是成百上千个 View 实例。Canvas 在底层使用了 Metal 加速，性能远超传统的视图层级。")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Advanced Graphics")
    }
}
