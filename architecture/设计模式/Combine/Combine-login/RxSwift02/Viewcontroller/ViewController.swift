//
//  ViewController.swift
//  CombineLoginDemo
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import Combine
import SnapKit

class ViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // UI 组件 (与 RxSwift 版本相同)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎登录"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextField = LoginTextField(placeholder: "请输入用户名")
    private let usernameValidationLabel = ValidationLabel()
    
    private let passwordTextField = LoginTextField(placeholder: "请输入密码", isSecure: true)
    private let passwordValidationLabel = ValidationLabel()
    
    private let rememberMeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("记住我", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // Combine Publishers
    private let usernameSubject = PassthroughSubject<String, Never>()
    private let passwordSubject = PassthroughSubject<String, Never>()
    private let loginTappedSubject = PassthroughSubject<Void, Never>()
    private let rememberMeChangedSubject = PassthroughSubject<Bool, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupTextFields()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        title = "登录"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            createSpacer(height: 40),
            usernameTextField,
            usernameValidationLabel,
            createSpacer(height: 16),
            passwordTextField,
            passwordValidationLabel,
            createSpacer(height: 24),
            rememberMeButton,
            createSpacer(height: 32),
            loginButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(stackView)
        view.addSubview(loadingIndicator)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview().offset(-40)
        }
        
        rememberMeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(loginButton)
        }
    }
    
    private func createSpacer(height: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return view
    }
    
    // MARK: - TextField Setup
    private func setupTextFields() {
        // 用户名文本框文本变化
        usernameTextField.textPublisher
            .sink { [weak self] text in
                self?.usernameSubject.send(text)
            }
            .store(in: &cancellables)
        
        // 密码文本框文本变化
        passwordTextField.textPublisher
            .sink { [weak self] text in
                self?.passwordSubject.send(text)
            }
            .store(in: &cancellables)
        
        // 登录按钮点击
        loginButton.tapPublisher
            .sink { [weak self] in
                self?.loginTappedSubject.send(())
            }
            .store(in: &cancellables)
        
        // 记住我按钮点击
        rememberMeButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.rememberMeButton.isSelected.toggle()
                self.rememberMeChangedSubject.send(self.rememberMeButton.isSelected)
            }
            .store(in: &cancellables)
        
        // 文本框回车键处理
        usernameTextField.returnPublisher
            .sink { [weak self] in
                self?.passwordTextField.becomeFirstResponder()
            }
            .store(in: &cancellables)
        
        passwordTextField.returnPublisher
            .sink { [weak self] in
                self?.passwordTextField.resignFirstResponder()
                if self?.loginButton.isEnabled == true {
                    self?.loginButton.sendActions(for: .touchUpInside)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        // 创建 Input
        let input = LoginViewModel.Input(
            username: usernameSubject.eraseToAnyPublisher(),
            password: passwordSubject.eraseToAnyPublisher(),
            loginTapped: loginTappedSubject.eraseToAnyPublisher(),
            rememberMeChanged: rememberMeChangedSubject.eraseToAnyPublisher()
        )
        
        // 转换并获取 Output
        let output = viewModel.transform(input: input)
        
        // 绑定用户名验证结果
        output.usernameValidation
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.updateUsernameValidation(result)
            }
            .store(in: &cancellables)
        
        // 绑定密码验证结果
        output.passwordValidation
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.updatePasswordValidation(result)
            }
            .store(in: &cancellables)
        
        // 绑定登录按钮状态
        output.loginButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.updateLoginButton(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
        
        // 绑定加载状态
        output.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading: isLoading)
            }
            .store(in: &cancellables)
        
        // 绑定登录结果
        output.loginResult
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.handleLoginResult(result)
            }
            .store(in: &cancellables)
        
        // 绑定记住我状态
        output.rememberMeState
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                self?.rememberMeButton.isSelected = isOn
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates (与 RxSwift 版本相同)
    private func updateUsernameValidation(_ result: ValidationResult) {
        usernameValidationLabel.text = result.message
        if result.isValid {
            usernameValidationLabel.validationState = .valid
            usernameTextField.setValidationState(.valid)
        } else if let message = result.message, !message.isEmpty {
            usernameValidationLabel.validationState = .invalid
            usernameTextField.setValidationState(.invalid)
        } else {
            usernameValidationLabel.validationState = .normal
            usernameTextField.setValidationState(.normal)
        }
    }
    
    private func updatePasswordValidation(_ result: ValidationResult) {
        passwordValidationLabel.text = result.message
        if result.isValid {
            passwordValidationLabel.validationState = .valid
            passwordTextField.setValidationState(.valid)
        } else if let message = result.message, !message.isEmpty {
            passwordValidationLabel.validationState = .invalid
            passwordTextField.setValidationState(.invalid)
        } else {
            passwordValidationLabel.validationState = .normal
            passwordTextField.setValidationState(.normal)
        }
    }
    
    private func updateLoginButton(isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.alpha = isEnabled ? 1.0 : 0.6
        loginButton.backgroundColor = isEnabled ? .systemBlue : .systemGray
    }
    
    private func updateLoadingState(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            loginButton.setTitle("", for: .normal)
        } else {
            loadingIndicator.stopAnimating()
            loginButton.setTitle("登录", for: .normal)
        }
    }
    
    private func handleLoginResult(_ result: LoginViewModel.LoginResult) {
        switch result {
        case .success(let user):
            showSuccessAlert(user: user)
        case .failure(let errorMessage):
            showErrorAlert(message: errorMessage)
        case .none:
            break
        }
    }
    
    // MARK: - Alert
    private func showSuccessAlert(user: User) {
        let alert = UIAlertController(
            title: "登录成功",
            message: "欢迎回来，\(user.username)！",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            // 跳转到主页
//            let homeVC = LoginViewController(user: user)
//            self.navigationController?.pushViewController(homeVC, animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "登录失败",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
