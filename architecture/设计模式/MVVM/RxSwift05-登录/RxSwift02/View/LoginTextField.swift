//
//  LoginTextField.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/11.
//

import Foundation
import SnapKit

class LoginTextField: UITextField {
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    init(placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        setupUI(placeholder: placeholder, isSecure: isSecure)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(placeholder: "", isSecure: false)
    }
    
    private func setupUI(placeholder: String, isSecure: Bool) {
        font = .systemFont(ofSize: 16)
        borderStyle = .none
        self.placeholder = placeholder
        isSecureTextEntry = isSecure
        
        addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
            make.height.equalTo(50)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(66)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    func setValidationState(_ state: ValidationLabel.ValidationState) {
        switch state {
        case .normal:
            borderView.layer.borderColor = UIColor.systemGray4.cgColor
        case .valid:
            borderView.layer.borderColor = UIColor.systemGreen.cgColor
        case .invalid:
            borderView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}
