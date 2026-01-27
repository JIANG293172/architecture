//
//  StrategyPatternViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 策略模式演示视图控制器
class StrategyPatternViewController: UIViewController {
    private let amountTextField = UITextField()
    private let strategySegmentedControl = UISegmentedControl()
    private let resultLabel = UILabel()
    private let calculateButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Strategy Pattern"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // Setup amount text field
        amountTextField.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        amountTextField.layer.borderWidth = 1.0
        amountTextField.layer.borderColor = UIColor.gray.cgColor
        amountTextField.layer.cornerRadius = 8.0
        amountTextField.placeholder = "Enter original amount"
        amountTextField.keyboardType = .decimalPad
        view.addSubview(amountTextField)
        
        // Setup strategy segmented control
        strategySegmentedControl.frame = CGRect(x: 50, y: 160, width: view.frame.width - 100, height: 40)
        strategySegmentedControl.insertSegment(withTitle: "Normal", at: 0, animated: false)
        strategySegmentedControl.insertSegment(withTitle: "80% Discount", at: 1, animated: false)
        strategySegmentedControl.insertSegment(withTitle: "Full Reduction", at: 2, animated: false)
        strategySegmentedControl.selectedSegmentIndex = 0
        view.addSubview(strategySegmentedControl)
        
        // Setup calculate button
        calculateButton.frame = CGRect(x: 100, y: 220, width: view.frame.width - 200, height: 44)
        calculateButton.setTitle("Calculate Final Amount", for: .normal)
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.backgroundColor = .blue
        calculateButton.layer.cornerRadius = 22
        view.addSubview(calculateButton)
        
        // Setup result label
        resultLabel.frame = CGRect(x: 50, y: 280, width: view.frame.width - 100, height: 40)
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.boldSystemFont(ofSize: 20)
        resultLabel.textColor = .black
        resultLabel.text = "Final Amount: $0.00"
        view.addSubview(resultLabel)
    }
    
    private func setupActions() {
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
    }
    
    @objc private func calculateButtonTapped() {
        // Get original amount from text field
        guard let amountText = amountTextField.text, let originalAmount = Double(amountText) else {
            resultLabel.text = "Please enter a valid amount"
            return
        }
        
        // Get selected strategy
        let strategy: PayStrategy
        switch strategySegmentedControl.selectedSegmentIndex {
        case 0:
            strategy = NormalPayStrategy()
        case 1:
            strategy = DiscountPayStrategy()
        case 2:
            strategy = FullReductionStrategy()
        default:
            strategy = NormalPayStrategy()
        }
        
        // Create order with selected strategy
        let order = Order(strategy: strategy)
        let finalAmount = order.getFinalAmount(original: originalAmount)
        
        // Update result label
        resultLabel.text = "Final Amount: $\(String(format: "%.2f", finalAmount))"
    }
}
