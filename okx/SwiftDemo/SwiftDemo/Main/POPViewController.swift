//
//  Demo7ViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/23.
//

//cd /Users/taojiang/Desktop/poxiao/architecture/okx/SwiftDemo && xcodebuild -workspace SwiftDemo.xcworkspace -scheme SwiftDemo -configuration Debug -sdk iphoneos build
//xcodebuild -workspace SwiftDemo.xcworkspace -scheme SwiftDemo -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=18.6' build

import UIKit

// MARK: - POP 实战示例：协议导向编程替代类继承

// 步骤1：拆分功能为「单一职责」的协议（接口隔离）
/// 可点击功能协议（只定义"点击"接口）
protocol Clickable {
    func click()
}

/// 可刷新功能协议（只定义"刷新"接口）
protocol Refreshable {
    func refresh()
}

/// 可滚动功能协议
protocol Scrollable {
    func scrollToTop()
}

// 步骤2：协议扩展提供默认实现（替代父类的默认方法）
extension Clickable {
    // 默认点击逻辑（所有遵循该协议的类型都能直接用）
    func click() {
        print("默认点击逻辑")
    }
}

extension Refreshable {
    // 默认刷新逻辑
    func refresh() {
        print("默认刷新逻辑")
    }
}

extension Scrollable {
    // 默认滚动逻辑
    func scrollToTop() {
        print("滚动到顶部")
    }
}

// 步骤3：类型遵循协议（组合功能，突破单继承）
/// 自定义按钮：组合「可点击+可刷新」功能
class CustomButton: UIButton, Clickable, Refreshable {
    // 重写点击逻辑（按需定制）
    func click() {
        print("按钮点击逻辑")
    }
    // 刷新用默认实现（无需重写）
}

/// 自定义列表：组合「可刷新+可滚动」功能
class CustomTableView: UITableView, Refreshable, Scrollable {
    // 重写刷新逻辑
    func refresh() {
        print("列表刷新逻辑")
    }
    // 滚动用默认实现
}

/// Extend system class with protocol: Add click functionality to UILabel
extension UILabel: Clickable {
    func click() {
        if let labelText = text {
            print("Label clicked: \(labelText)")
        } else {
            print("Label clicked: No text")
        }
    }
}

// 步骤4：协议约束实现多态（替代继承的多态）
func handleClick(_ view: Clickable) {
    view.click() // 无论传入Button/Label，都能调用click()，和继承多态效果一致
}

func handleRefresh(_ component: Refreshable) {
    component.refresh()
}

class POPViewController: UIViewController {
    
    private let customButton = CustomButton(type: .system)
    private let customTableView = CustomTableView()
    private let clickableLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "POP Practical Example"
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
        demonstratePOP()
    }
    
    private func setupUI() {
        // Setup button
        customButton.setTitle("Click Me", for: .normal)
        customButton.setTitleColor(.blue, for: .normal)
        customButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        view.addSubview(customButton)
        
        // Setup label
        clickableLabel.text = "This is a clickable label"
        clickableLabel.textAlignment = .center
        clickableLabel.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        clickableLabel.backgroundColor = .lightGray
        view.addSubview(clickableLabel)
        
        // Setup table view
        customTableView.frame = CGRect(x: 50, y: 300, width: 300, height: 200)
        customTableView.backgroundColor = .lightGray
        view.addSubview(customTableView)
    }
    
    private func setupActions() {
        // Button tap event
        customButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Label tap event
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        clickableLabel.isUserInteractionEnabled = true
        clickableLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonTapped() {
        // Directly call button's click method
        customButton.click()
        // Call button's refresh method
        customButton.refresh()
    }
    
    @objc private func labelTapped() {
        // Call label's click method
        clickableLabel.click()
    }
    
    private func demonstratePOP() {
        print("\n=== POP Practical Demonstration ===")
        
        // 1. Demonstrate protocol polymorphism
        print("\n1. Protocol Polymorphism Demo:")
        handleClick(customButton)  // Pass button
        handleClick(clickableLabel) // Pass label
        
        // 2. Demonstrate function composition
        print("\n2. Function Composition Demo:")
        handleRefresh(customButton) // Button can refresh
        handleRefresh(customTableView) // TableView can refresh
        
        // 3. Demonstrate default implementation
        print("\n3. Default Implementation Demo:")
        customTableView.scrollToTop() // Use default scroll implementation
        
        // 4. Demonstrate system class extension
        print("\n4. System Class Extension Demo:")
        let systemButton = UIButton(type: .system)
        // Note: System UIButton doesn't have click() method by default
        // because we didn't extend UIButton with Clickable protocol
        // systemButton.click() // This line would error
        
        print("\n=== POP Advantages Summary ===")
        print("✅ Break single inheritance limit: A type can conform to multiple protocols")
        print("✅ Single responsibility, no redundancy: Only compose needed functions")
        print("✅ Flexibly extend system classes: Directly add click functionality to UILabel")
        print("✅ Low coupling, easy refactoring: Modifying protocols doesn't affect unrelated types")
        print("✅ Support value types: Structs/enums can also conform to protocols")
    }
}

// MARK: - Additional Example: Value Types Conforming to Protocols

// Define a printable protocol
protocol Printable {
    func printDescription()
}

extension Printable {
    func printDescription() {
        print("Default print description")
    }
}

// Struct conforming to protocol (value types can't inherit, but can conform to protocols)
struct Person: Printable {
    var name: String
    var age: Int
    
    func printDescription() {
        print("Person: \(name), \(age) years old")
    }
}

// Enum conforming to protocol
enum Status: Printable {
    case active, inactive, pending
    
    func printDescription() {
        print("Status: \(self)")
    }
}
