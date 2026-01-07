//
//  LoginViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/11.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class LoginViewController: UIViewController {
    
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "主页"
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "欢迎，\(user.username)！"
        welcomeLabel.font = .systemFont(ofSize: 24, weight: .medium)
        welcomeLabel.textAlignment = .center
        
        let emailLabel = UILabel()
        emailLabel.text = "邮箱：\(user.email)"
        emailLabel.font = .systemFont(ofSize: 16)
        emailLabel.textColor = .systemGray
        emailLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    
    
    
    
    
}
