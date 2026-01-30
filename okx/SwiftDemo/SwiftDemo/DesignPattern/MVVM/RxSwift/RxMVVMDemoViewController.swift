import UIKit
import RxSwift
import RxCocoa

/// RxSwift 版本的 MVVM 实战演示
class RxMVVMDemoViewController: UIViewController {
    
    private let viewModel = RxMVVMLoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let statusLabel = UILabel()
    private let operatorDemoButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "MVVM + RxSwift Demo"
        view.backgroundColor = .systemGroupedBackground
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        titleLabel.text = "用户登录 (RxSwift)"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        usernameTextField.placeholder = "用户名 (至少3位)"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "密码 (至少6位)"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .disabled)
        loginButton.layer.cornerRadius = 8
        
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 14)
        
        operatorDemoButton.setTitle("运行 Rx 操作符演示 (控制台输出)", for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            passwordTextField,
            loginButton,
            statusLabel,
            operatorDemoButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        // 1. 输入绑定 (Two-way binding equivalent in logic)
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
            
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
            
        loginButton.rx.tap
            .bind(to: viewModel.loginTapped)
            .disposed(by: disposeBag)
            
        operatorDemoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.runCommonRxOperatorsDemo()
            })
            .disposed(by: disposeBag)
            
        // 2. 输出绑定
        viewModel.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
            
        viewModel.isLoginEnabled
            .map { $0 ? 1.0 : 0.5 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
            
        viewModel.isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
            
        viewModel.isLoading
            .subscribe(onNext: { [weak self] loading in
                self?.loginButton.setTitle(loading ? "" : "登录", for: .normal)
                self?.usernameTextField.isEnabled = !loading
                self?.passwordTextField.isEnabled = !loading
            })
            .disposed(by: disposeBag)
            
        viewModel.loginResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let user):
                    self?.statusLabel.textColor = .systemGreen
                    self?.statusLabel.text = "登录成功！欢迎，\(user.username)\nToken: \(user.token)"
                case .failure:
                    self?.statusLabel.textColor = .systemRed
                }
            })
            .disposed(by: disposeBag)
            
        viewModel.errorMessage
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
