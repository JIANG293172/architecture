//
//  StrategyPatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 策略模式演示视图控制器
/// 策略模式：定义一系列算法，把它们封装起来，使它们可以互相替换。
/// 策略模式让算法的变化独立于使用算法的客户。
class StrategyPatternViewController: UIViewController {
    /// 输入原始金额的文本字段
    private let amountTextField = UITextField()
    /// 选择支付策略的分段控件
    private let strategySegmentedControl = UISegmentedControl()
    /// 显示计算结果的标签
    private let resultLabel = UILabel()
    /// 触发计算的按钮
    private let calculateButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Strategy Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置金额文本字段
        amountTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        amountTextField.layer.borderWidth = 1.0
        amountTextField.layer.borderColor = UIColor.gray.cgColor
        amountTextField.layer.cornerRadius = 8.0
        amountTextField.placeholder = "Enter original amount"
        amountTextField.keyboardType = .decimalPad
        view.addSubview(amountTextField)
        
        // 设置策略选择分段控件
        strategySegmentedControl.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 40)
        strategySegmentedControl.insertSegment(withTitle: "Normal", at: 0, animated: false)
        strategySegmentedControl.insertSegment(withTitle: "80% Discount", at: 1, animated: false)
        strategySegmentedControl.insertSegment(withTitle: "Full Reduction", at: 2, animated: false)
        strategySegmentedControl.selectedSegmentIndex = 0
        view.addSubview(strategySegmentedControl)
        
        // 设置计算按钮
        calculateButton.frame = CGRect(x: 100, y: 220, width: view.frame.width - 200, height: 44)
        calculateButton.setTitle("Calculate Final Amount", for: .normal)
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.backgroundColor = .blue
        calculateButton.layer.cornerRadius = 22
        view.addSubview(calculateButton)
        
        // 设置结果标签
        resultLabel.frame = CGRect(x: 50, y: 280, width: view.frame.width - 100, height: 40)
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.boldSystemFont(ofSize: 20)
        resultLabel.textColor = .black
        resultLabel.text = "Final Amount: $0.00"
        view.addSubview(resultLabel)
    }
    
    /// 设置按钮动作
    private func setupActions() {
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
    }
    
    /// 处理计算按钮点击事件
    /// 思路：
    /// 1. 获取用户输入的原始金额
    /// 2. 根据选择的策略类型创建对应的策略实例
    /// 3. 创建订单实例，并传入选择的策略
    /// 4. 调用订单的getFinalAmount方法计算最终金额
    /// 5. 更新结果标签显示最终金额
    @objc private func calculateButtonTapped() {
        // 获取原始金额
        guard let amountText = amountTextField.text, let originalAmount = Double(amountText) else {
            resultLabel.text = "Please enter a valid amount"
            return
        }
        
        // 根据选择的分段控件索引创建对应的支付策略
        // 策略模式的核心：根据不同的选择，创建不同的策略实例
        let strategy: PayStrategy
        switch strategySegmentedControl.selectedSegmentIndex {
        case 0:
            // 普通支付策略：不做任何折扣
            strategy = NormalPayStrategy()
        case 1:
            // 折扣支付策略：80%折扣
            strategy = DiscountPayStrategy()
        case 2:
            // 满减支付策略：满100减20
            strategy = FullReductionStrategy()
        default:
            // 默认使用普通支付策略
            strategy = NormalPayStrategy()
        }
        
        // 创建订单实例，并传入选择的支付策略
        // 订单类依赖于PayStrategy协议，而不是具体的策略实现
        let order = Order(strategy: strategy)
        
        // 调用订单的方法计算最终金额
        // 订单类通过策略接口调用具体策略的计算方法
        let finalAmount = order.getFinalAmount(original: originalAmount)
        
        // 更新结果标签
        resultLabel.text = "Final Amount: $\(String(format: "%.2f", finalAmount))"
    }
}
