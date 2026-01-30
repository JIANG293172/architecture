import UIKit
import Combine

/// MVVM & Combine 深度实战演示
/// 1. 展示 MVVM 登录实战
/// 2. 详细讲解 Combine 原理与 API
/// 3. 演示 Future 与 Swift Concurrency (Task) 的集成
class MVVMDemoViewController: UIViewController {
    
    private let viewModel = MVVMLoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // 使用单独的 view 类管理 UI 元素
    private let loginView = MVVMLoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM + Combine 实战"
        setupView()
        setupBindings()
    }
    
    private func setupView() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginView)
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 设置按钮点击事件
        loginView.combineDemoButton.addTarget(self, action: #selector(runCombineDemos), for: .touchUpInside)
    }
    
    private func setupBindings() {
        // MARK: - View -> ViewModel (输入)
        
        // 用户名改变
//        NotificationCenter.Publisher 嵌套的Publisher，可以自定义一些Noti的变量
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: loginView.usernameField)
//            .compactMap { ($0.object as? UITextField)?.text } // 用于转换和过滤
            .sink { [weak self] text in
                if let textFiled = text.object as? UITextField {
                    self?.viewModel.username = textFiled.text ?? ""
                }
            }
            .store(in: &cancellables)
            
        // 密码改变
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: loginView.passwordField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                self?.viewModel.password = text
            }
            .store(in: &cancellables)
            
        // 按钮点击
        loginView.loginFutureButton.addTarget(self, action: #selector(loginWithFuture), for: .touchUpInside)
        loginView.loginTaskButton.addTarget(self, action: #selector(loginWithTask), for: .touchUpInside)
        
        // MARK: - ViewModel -> View (输出)
        
        // 登录按钮状态
        viewModel.$isLoginEnabled
            .receive(on: RunLoop.main)
            .assign(to: \UIButton.isEnabled, on: loginView.loginFutureButton)
            .store(in: &cancellables)
            
        viewModel.$isLoginEnabled
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginView.loginTaskButton)
            .store(in: &cancellables)
            
        // 加载状态
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loginView.activityIndicator.startAnimating()
                    self?.loginView.statusLabel.text = "正在登录..."
                } else {
                    self?.loginView.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
            
        // 错误消息
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] msg in
                self?.loginView.statusLabel.textColor = .systemRed
                self?.loginView.statusLabel.text = "错误: \(msg)"
            }
            .store(in: &cancellables)
            
        // 登录成功
        viewModel.$loginUser
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.loginView.statusLabel.textColor = .systemGreen
                self?.loginView.statusLabel.text = "登录成功！\n欢迎, \(user.username)\nToken: \(user.token)"
            }
            .store(in: &cancellables)
    }
    
    @objc private func loginWithFuture() {
        viewModel.loginWithFuture()
    }
    
    @objc private func loginWithTask() {
        viewModel.loginWithTask()
    }
    
    @objc private func runCombineDemos() {
        viewModel.runCommonCombineDemos()
    }
}
