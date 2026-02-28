import SwiftUI

// MARK: - 2. MatchedGeometryEffect Demo
/// 原理：
/// matchedGeometryEffect 用于在两个不同的视图之间创建平滑的过渡动画。
/// 它通过一个唯一的 ID 和 命名空间 (Namespace) 来同步两个视图的几何属性（位置和大小）。
///
/// 使用方式：
/// 1. 使用 @Namespace 声明一个命名空间。
/// 2. 在两个视图上应用 .matchedGeometryEffect(id: "someID", in: namespace)。
/// 3. 通过状态切换来显示其中一个视图，SwiftUI 会自动计算它们之间的补间动画。

struct MatchedGeometryDemo: View {
    @Namespace private var animationNamespace
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            if !isExpanded {
                // 收起状态
                VStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.orange)
                        .matchedGeometryEffect(id: "shape", in: animationNamespace)
                        .frame(width: 100, height: 100)
                    
                    Text("Click to Expand")
                        .font(.headline)
                        .matchedGeometryEffect(id: "text", in: animationNamespace)
                }
                .padding()
            } else {
                // 展开状态
                VStack {
                    Text("Expanded View")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "text", in: animationNamespace)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.orange)
                        .matchedGeometryEffect(id: "shape", in: animationNamespace)
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .padding()
                }
            }
            
            Button(isExpanded ? "Collapse" : "Expand") {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
            
            Text("面试要点：matchedGeometryEffect 是实现 Hero Animation（英雄动画）的标准方式。它不像 UIKit 需要复杂的过渡代理，只需共享 ID 和 Namespace 即可。注意：切换时必须保证一个视图消失，另一个视图出现。")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Hero Animation")
    }
}
