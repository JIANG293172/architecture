//
//  FacadePatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 外观模式演示视图控制器
/// 外观模式：为子系统中的一组接口提供一个一致的界面，定义一个高层接口，使得子系统更加容易使用。
/// 外观模式的核心组件：
/// 1. 外观（Facade）：提供一个统一的接口，封装子系统的复杂性
/// 2. 子系统（Subsystem）：由多个相互关联的类组成，实现具体功能
/// 3. 客户端（Client）：通过外观接口与子系统交互，不需要知道子系统的具体实现
class FacadePatternViewController: UIViewController {
    /// 输入支付金额的文本字段
    private let amountTextField = UITextField()
    /// 选择支付方式的分段控件
    private let paymentTypeSegmentedControl = UISegmentedControl()
    /// 触发支付的按钮
    private let payButton = UIButton(type: .system)
    /// 显示支付结果的标签
    private let resultLabel = UILabel()
    /// 支付外观：封装了不同支付方式的复杂性，提供统一的支付接口
    private let paymentFacade = PaymentFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facade Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置金额文本字段
        amountTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        amountTextField.placeholder = "Enter payment amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.layer.borderWidth = 1.0
        amountTextField.layer.borderColor = UIColor.gray.cgColor
        amountTextField.layer.cornerRadius = 8.0
        view.addSubview(amountTextField)
        
        // 设置支付方式分段控件
        paymentTypeSegmentedControl.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 40)
        paymentTypeSegmentedControl.insertSegment(withTitle: "Alipay", at: 0, animated: false)
        paymentTypeSegmentedControl.insertSegment(withTitle: "WeChat Pay", at: 1, animated: false)
        paymentTypeSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(paymentTypeSegmentedControl)
        
        // 设置支付按钮
        payButton.frame = CGRect(x: 100, y: 220, width: view.frame.width - 200, height: 44)
        payButton.setTitle("Pay Now", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .blue
        payButton.layer.cornerRadius = 22
        view.addSubview(payButton)
        
        // 设置结果标签
        resultLabel.frame = CGRect(x: 50, y: 280, width: view.frame.width - 100, height: 100)
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.systemFont(ofSize: 16)
        resultLabel.textColor = .black
        resultLabel.text = "Payment Result:\n"
        resultLabel.numberOfLines = 0
        resultLabel.layer.borderWidth = 1.0
        resultLabel.layer.borderColor = UIColor.gray.cgColor
        resultLabel.layer.cornerRadius = 8.0
        view.addSubview(resultLabel)
    }
    
    /// 设置按钮动作
    private func setupActions() {
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    /// 处理支付按钮点击事件
    /// 思路：
    /// 1. 获取用户输入的支付金额
    /// 2. 获取选择的支付方式
    /// 3. 通过支付外观处理支付，不需要关心具体的支付实现
    /// 4. 更新结果标签显示支付结果
    @objc private func payButtonTapped() {
        // 获取支付金额
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            resultLabel.text = "Payment Result:\nPlease enter a valid amount"
            return
        }
        
        // 获取选择的支付方式
        let paymentType = paymentTypeSegmentedControl.selectedSegmentIndex == 0 ? "alipay" : "wechat"
        let paymentTypeName = paymentTypeSegmentedControl.selectedSegmentIndex == 0 ? "Alipay" : "WeChat Pay"
        
        // 调用支付外观处理支付：外观模式的核心操作
        // 客户端只需要调用外观的pay方法，不需要知道具体的支付实现
        // 外观会根据支付类型选择对应的支付方式，并处理所有的支付流程
        paymentFacade.pay(amount: amount, type: paymentType)
        
        // 更新结果标签
        resultLabel.text = "Payment Result:\nAmount: $\(String(format: "%.2f", amount))\nMethod: \(paymentTypeName)\nStatus: Payment processed successfully"
    }
}
