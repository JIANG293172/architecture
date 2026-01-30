import UIKit

class MVVMLoginView: UIView {
    
    // UI 元素
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    // 登录区域
    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginFutureButton = UIButton(type: .system)
    let loginTaskButton = UIButton(type: .system)
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let statusLabel = UILabel()
    
    // 演示区域
    let combineDemoButton = UIButton(type: .system)
    let refreshDemoButton = UIButton(type: .system)
    let explanationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        
        // 1. ScrollView 布局
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 2. 登录演示区域标题
        addHeader(title: "MVVM 登录演示 (admin / 123456)")
        
        usernameField.placeholder = "用户名 (至少3位)"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        stackView.addArrangedSubview(usernameField)
        
        passwordField.placeholder = "密码 (至少6位)"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        stackView.addArrangedSubview(passwordField)
        
        let buttonStack = UIStackView()
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        
        loginFutureButton.setTitle("Future 登录", for: .normal)
        loginFutureButton.backgroundColor = .systemBlue
        loginFutureButton.setTitleColor(.white, for: .normal)
        loginFutureButton.layer.cornerRadius = 8
        buttonStack.addArrangedSubview(loginFutureButton)
        
        loginTaskButton.setTitle("Task 登录", for: .normal)
        loginTaskButton.backgroundColor = .systemIndigo
        loginTaskButton.setTitleColor(.white, for: .normal)
        loginTaskButton.layer.cornerRadius = 8
        buttonStack.addArrangedSubview(loginTaskButton)
        
        stackView.addArrangedSubview(buttonStack)
        
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 14)
        stackView.addArrangedSubview(statusLabel)
        
        stackView.addArrangedSubview(activityIndicator)
        
        // 3. Combine 原理解析
        addHeader(title: "Combine 核心原理解析")
        
        explanationLabel.numberOfLines = 0
        explanationLabel.font = .systemFont(ofSize: 14)
        explanationLabel.textColor = .darkGray
        explanationLabel.text = """
        • Publisher (发布者): 负责产生数据事件 (Value 或 Completion)。
        • Subscriber (订阅者): 负责接收并处理事件 (sink, assign)。
        • Operator (操作符): 在发布者和订阅者之间转换数据 (map, filter, combineLatest)。
        
        • Future: 适用于单次异步任务，产生一个结果后立即结束。
        • @Published: 属性包装器，自动为属性创建 Publisher。
        • AnyCancellable: 内存管理，订阅后返回，销毁时自动取消订阅。
        """
        stackView.addArrangedSubview(explanationLabel)
        
        combineDemoButton.setTitle("运行更多 Combine API 演示 (控制台查看)", for: .normal)
        stackView.addArrangedSubview(combineDemoButton)
        
        // 添加刷新频率控制演示按钮
        refreshDemoButton.setTitle("Combine 刷新频率控制演示", for: .normal)
        refreshDemoButton.backgroundColor = .systemGreen
        refreshDemoButton.setTitleColor(.white, for: .normal)
        refreshDemoButton.layer.cornerRadius = 8
        stackView.addArrangedSubview(refreshDemoButton)
    }
    
    private func addHeader(title: String) {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(label)
    }
}
