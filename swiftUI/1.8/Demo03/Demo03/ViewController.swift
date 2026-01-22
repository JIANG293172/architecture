import UIKit
import SwiftUI

// 1. 定义一个SwiftUI视图（基础入门组件）
struct SwiftUIBasicView: View {
    // 状态变量（SwiftUI的响应式核心）
    @State private var count = 0
    @State private var name = ""
    
    var body: some View {
        // 垂直布局容器
        VStack(spacing: 20) {
            // 文本组件
            Text("Swift")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            // 输入框组件
            TextField("请输入姓名", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            
            // 计数器文本
            Text("点击次数: \(count)")
                .font(.system(size: 18))
            
            // 水平布局的按钮组
            HStack(spacing: 30) {
                // 按钮组件（减一）
                Button(action: {
                    count -= 1
                }) {
                    Text("-")
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                
                // 按钮组件（加一）
                Button(action: {
                    count += 1
                }) {
                    Text("+")
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            
            // 条件渲染的文本
            if !name.isEmpty {
                Text("你好，\(name)!")
                    .font(.system(size: 18))
                    .foregroundColor(.purple)
            }
        }
        .padding()
    }
}

// 2. 在UIViewController中嵌入SwiftUI视图
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 创建SwiftUI视图的包装器
        let swiftUIView = SwiftUIBasicView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 将SwiftUI视图添加到当前ViewController
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // 设置布局约束
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
