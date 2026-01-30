import UIKit
import Combine
import CombineDataBus

/// CombineDataBus 跨组件通讯演示
class DataBusDemoViewController: UIViewController {
    
    private let stackView = UIStackView()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine DataBus 跨组件通讯"
        view.backgroundColor = .systemBackground
        setupUI()
        setupGlobalObserver()
    }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // 添加两个相互隔离的子组件
        let componentA = ComponentAViewController()
        let componentB = ComponentBViewController()
        
        addChild(componentA)
        stackView.addArrangedSubview(componentA.view)
        componentA.didMove(toParent: self)
        
        addChild(componentB)
        stackView.addArrangedSubview(componentB.view)
        componentB.didMove(toParent: self)
        
        // 添加一个控制面板
        setupControlPanel()
    }
    
    private func setupControlPanel() {
        let panel = UIView()
        panel.backgroundColor = .systemGray6
        panel.layer.cornerRadius = 12
        stackView.addArrangedSubview(panel)
        
        let label = UILabel()
        label.text = "全局控制台 (不直接引用 A/B 组件)"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(label)
        
        let button = UIButton(type: .system)
        button.setTitle("发布全局警告 (Topic: Alert)", for: .normal)
        button.addTarget(self, action: #selector(postGlobalAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: panel.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            button.centerXAnchor.constraint(equalTo: panel.centerXAnchor)
        ])
    }
    
    @objc private func postGlobalAlert() {
        CombineDataBus.shared.post(DataBusTopics.alert, event: "⚠️ 这是从主容器发出的全局警告！")
    }
    
    private func setupGlobalObserver() {
        // 演示：主容器也可以监听所有数据流
        CombineDataBus.shared.publisher(for: DataBusTopics.alert)
            .sink { msg in
                print("Container received alert: \(msg)")
            }
            .store(in: &cancellables)
    }
}

// MARK: - 子组件 A

class ComponentAViewController: UIViewController {
    private let statusLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        statusLabel.text = "组件 A: 未登录"
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        loginButton.setTitle("切换登录状态", for: .normal)
        loginButton.addTarget(self, action: #selector(toggleLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func toggleLogin() {
        let current = CombineDataBus.shared.currentState(for: DataBusTopics.login) ?? false
        CombineDataBus.shared.sync(DataBusTopics.login, state: !current)
    }
    
    private func setupBindings() {
        // 监听登录状态
        CombineDataBus.shared.statePublisher(for: DataBusTopics.login, initialValue: false)
            .sink { [weak self] isLoggedIn in
                self?.statusLabel.text = "组件 A: \(isLoggedIn ? "✅ 已登录" : "❌ 未登录")"
            }
            .store(in: &cancellables)
            
        // 监听全局警告
        CombineDataBus.shared.publisher(for: DataBusTopics.alert)
            .sink { [weak self] msg in
                self?.view.backgroundColor = .systemRed.withAlphaComponent(0.2)
                UIView.animate(withDuration: 1.0) {
                    self?.view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - 子组件 B

class ComponentBViewController: UIViewController {
    private let statusLabel = UILabel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        statusLabel.text = "组件 B: 等待数据..."
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
//    ### 一、核心作用：类型擦除与接口统一 1. 隐藏具体实现细节
//    - 具体类型 ： PassthroughSubject<T, Never> 是一个具体的发布者类型，包含了其特有的方法（如 send() 、 send(completion:) ）。
//    - 类型擦除 ： eraseToAnyPublisher() 会创建一个 AnyPublisher<T, Never> 实例，它是一个 类型擦除的包装器 ，隐藏了底层的具体实现。
//    - 防止滥用 ：外部代码无法直接调用 send() 方法（因为 AnyPublisher 没有这个方法），只能订阅它，确保了发布者的封装性。 2. 提供统一的接口
//    - 返回类型一致性 ：无论内部使用何种具体的发布者类型（ PassthroughSubject 、 CurrentValueSubject 或其他），对外都返回统一的 AnyPublisher 类型。
//    - 简化 API 设计 ：调用方不需要关心内部实现细节，只需要与标准的 AnyPublisher 接口交互。
//    - 增强可维护性 ：如果未来内部实现需要更换（如从 PassthroughSubject 改为其他发布者），对外的 API 不会受到影响。
    private func setupBindings() {
        // 监听来自 A 的登录状态
        CombineDataBus.shared.statePublisher(for: DataBusTopics.login, initialValue: false)
            .sink { [weak self] isLoggedIn in
                self?.statusLabel.text = "组件 B 同步 A 的状态: \n\(isLoggedIn ? "用户已上线" : "用户已下线")"
            }
            .store(in: &cancellables)
            
        // 监听全局警告
        CombineDataBus.shared.publisher(for: DataBusTopics.alert)
            .sink { [weak self] msg in
                let alert = UIAlertController(title: "收到 DataBus 消息", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}
