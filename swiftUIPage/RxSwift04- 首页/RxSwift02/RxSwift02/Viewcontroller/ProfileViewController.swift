//
//  ProfileViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/10.
//

import Foundation
import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDta()
    }
    
    
    func setupUI() {
        title = "个人资料"
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    
    func configureDta() {
        nameLabel.text = "RxSwift 用户"
        emailLabel.text = "user@163.com"
    }
    
    
    
    
    
}
