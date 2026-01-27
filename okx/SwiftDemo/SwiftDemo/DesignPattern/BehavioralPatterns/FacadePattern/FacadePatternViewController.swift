//
//  FacadePatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 外观模式演示视图控制器
class FacadePatternViewController: UIViewController {
    private let amountTextField = UITextField()
    private let paymentTypeSegmentedControl = UISegmentedControl()
    private let payButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let paymentFacade = PaymentFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facade Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // Setup amount text field
        amountTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        amountTextField.placeholder = "Enter payment amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.layer.borderWidth = 1.0
        amountTextField.layer.borderColor = UIColor.gray.cgColor
        amountTextField.layer.cornerRadius = 8.0
        view.addSubview(amountTextField)
        
        // Setup payment type segmented control
        paymentTypeSegmentedControl.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 40)
        paymentTypeSegmentedControl.insertSegment(withTitle: "Alipay", at: 0, animated: false)
        paymentTypeSegmentedControl.insertSegment(withTitle: "WeChat Pay", at: 1, animated: false)
        paymentTypeSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(paymentTypeSegmentedControl)
        
        // Setup pay button
        payButton.frame = CGRect(x: 100, y: 220, width: view.frame.width - 200, height: 44)
        payButton.setTitle("Pay Now", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .blue
        payButton.layer.cornerRadius = 22
        view.addSubview(payButton)
        
        // Setup result label
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
    
    private func setupActions() {
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    @objc private func payButtonTapped() {
        // Get payment amount from text field
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            resultLabel.text = "Payment Result:\nPlease enter a valid amount"
            return
        }
        
        // Get selected payment type
        let paymentType = paymentTypeSegmentedControl.selectedSegmentIndex == 0 ? "alipay" : "wechat"
        let paymentTypeName = paymentTypeSegmentedControl.selectedSegmentIndex == 0 ? "Alipay" : "WeChat Pay"
        
        // Call payment facade to process payment
        paymentFacade.pay(amount: amount, type: paymentType)
        
        // Update result label
        resultLabel.text = "Payment Result:\nAmount: $\(String(format: "%.2f", amount))\nMethod: \(paymentTypeName)\nStatus: Payment processed successfully"
    }
}
