//
//  ViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    private let passwordTextField = LoginTextField(placeholder: "请输入Miami", isSecure: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
               setupBindings()
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
        
        // MARK: - Bindings
        private func setupBindings() {
            // 创建 Input
            let input = LoginViewModel.Input(
                username: usernameTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable(),
                loginTapped: loginButton.rx.tap.asObservable(),
                rememberMeChanged: rememberMeButton.rx.tap.map { [weak self] in
                    guard let self = self else { return false }
                    self.rememberMeButton.isSelected.toggle()
                    return self.rememberMeButton.isSelected
                }
            )
            
            // 转换并获取 Output
            let output = viewModel.transform(input: input)
            
            // 绑定用户名验证结果
            output.usernameValidation
                .drive(onNext: { [weak self] result in
                    self?.updateUsernameValidation(result)
                })
                .disposed(by: disposeBag)
            
            // 绑定密码验证结果
            output.passwordValidation
                .drive(onNext: { [weak self] result in
                    self?.updatePasswordValidation(result)
                })
                .disposed(by: disposeBag)
            
            // 绑定登录按钮状态
            output.loginButtonEnabled
                .drive(onNext: { [weak self] isEnabled in
                    self?.updateLoginButton(isEnabled: isEnabled)
                })
                .disposed(by: disposeBag)
            
            // 绑定加载状态
            output.isLoading
                .drive(onNext: { [weak self] isLoading in
                    self?.updateLoadingState(isLoading: isLoading)
                })
                .disposed(by: disposeBag)
            
            // 绑定登录结果
            output.loginResult
                .drive(onNext: { [weak self] result in
                    self?.handleLoginResult(result)
                })
                .disposed(by: disposeBag)
            
            // 绑定记住我状态
            output.rememberMeState
                .drive(onNext: { [weak self] isOn in
                    self?.rememberMeButton.isSelected = isOn
                })
                .disposed(by: disposeBag)
            
            // 文本框回车键处理
            usernameTextField.rx.controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: { [weak self] in
                    self?.passwordTextField.becomeFirstResponder()
                })
                .disposed(by: disposeBag)
            
            passwordTextField.rx.controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: { [weak self] in
                    self?.passwordTextField.resignFirstResponder()
                    if self?.loginButton.isEnabled == true {
                        self?.loginButton.sendActions(for: .touchUpInside)
                    }
                })
                .disposed(by: disposeBag)
        }
        
        // MARK: - UI Updates
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
                let homeVC = LoginViewController(user: user)
                self.navigationController?.pushViewController(homeVC, animated: true)
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

