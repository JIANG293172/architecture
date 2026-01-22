//
//  ValidationLabel.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/11.
//

import Foundation
import UIKit
import SnapKit


class ValidationLabel: UILabel {
    
    enum ValidationState {
        case normal
        case valid
        case invalid
    }
    
    var validationState: ValidationState = .normal {
        didSet {
            updateAppearance()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        font = .systemFont(ofSize: 12)
        numberOfLines = 0
        updateAppearance()
    }
    
    private func updateAppearance() {
        
        switch validationState {
        case .normal:
            textColor = .systemGray
            isHidden = true
        case .valid:
            textColor = .systemGreen
            isHidden = false
        case .invalid:
            textColor = .systemRed
            isHidden = false
        }
    }
    
    
}



