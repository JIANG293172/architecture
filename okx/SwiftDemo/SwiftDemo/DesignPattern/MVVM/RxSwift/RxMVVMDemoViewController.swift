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
        
        operatorDemoButton.setTitle("🚀 运行 RxSwift 全面特性演示 (控制台)", for: .normal)
        operatorDemoButton.backgroundColor = .systemOrange
        operatorDemoButton.setTitleColor(.white, for: .normal)
        operatorDemoButton.layer.cornerRadius = 8
        operatorDemoButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        operatorDemoButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
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
    
    /// 不管是 将用户相应，转化到viewmodel里面的变量（变成可监听的发布者）
    /// 还是处理完后的数据，存入viewmodel中的变量（也是变成发布者）
    /// 输入和输出都是围绕着 将事件处理后的结果，传入发布者， 然后通过发布者把数据和事件传出去。
    ///
    /// 不管是combine 还是 rxswift
    /// 他们都是想尽可能的把用户操作，通过操作符号，转化成 发布者，然后发布出去给监听对象，同时也想监听对象那么sink处理事件，那么直接绑定的到用户UI上。
    ///
    ///
    ///
    /// 如果用一句话来再总结你的观点：
//   - 以前 ：你在写“当 A 发生时，我去改 B，再去改 C”。（容易出错，状态难追踪）
//   - 现在 ：你在写“B 是由 A 转化来的，C 是由 B 转化来的”。（逻辑清晰，自动联动）
//   你在 CombineUIExtensions.swift 中所做的封装，本质上就是 消灭 UI 层的“命令式”噪音 ，让 UI 彻底变成一个“发布者”，从而完美地融入到这个单向循环的流水线中。
//
//   你的理解已经非常到位，这种“流”式思维是开发大型复杂 App、处理高并发 UI 逻辑的基石。
    
    
//    - 关于“输入”与“输出”的统一性 ：
//    你敏锐地察觉到，无论是 UI 传给 VM 的（Input），还是 VM 传给 UI 的（Output），最终都变成了 发布者（Publisher/Observable） 。这意味着在响应式编程中， 数据（Data）和事件（Event）不再有边界 。一个按钮点击是一个事件流，一个用户名的字符串也是一个状态流。
//    - 关于“操作符（Operators）”的价值 ：
//    你提到的“通过操作符转化”，实际上是响应式编程最强大的地方。它把复杂的业务逻辑（如防抖、过滤、合并、异步转换）从“命令式”的 if-else 和 Delegate 变成了“声明式”的 流水线（Pipeline） 。
    
    
    

    
    private func setupBindings() {
        // 1. 输入绑定 (Two-way binding equivalent in logic)
        // 将用户输入转成 publisher 发布者
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
                self?.viewModel.runComprehensiveRxDemo()
            })
            .disposed(by: disposeBag)
            
        
        /// 订阅者，订阅和监听结果的变化
        
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
