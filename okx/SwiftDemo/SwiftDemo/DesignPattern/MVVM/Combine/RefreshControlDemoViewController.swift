import UIKit
import Combine

/// 刷新频率控制演示页面
/// 展示如何使用 Combine 控制多个数据源的 UI 刷新频率
class RefreshControlDemoViewController: UIViewController {
    
    // MARK: - UI 元素
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let refreshButton = UIButton(type: .system)
    private let timerButton = UIButton(type: .system)
    private let manualButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let dataLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Combine 属性
    
    private var cancellables = Set<AnyCancellable>()
    
//    - Publisher ：所有数据流的基础抽象，被动触发，不可手动控制。
//    - Subject ：特殊的 Publisher ，可手动发送值和完成事件，适合手动触发事件或管理状态。
    private let refreshTrigger = PassthroughSubject<Void, Never>()
    private var timer: AnyCancellable?
    
    // MARK: - 数据属性
    
    private var refreshCount = 0
    private var lastRefreshTime: Date?
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine 刷新频率控制"
        setupView()
        setupRefreshControl()
        setupBindings()
    }
    
    // MARK: - 视图设置
    
    private func setupView() {
        view.backgroundColor = .systemGroupedBackground
        
        // 配置 ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.refreshControl = refreshControl
        view.addSubview(scrollView)
        
        // 配置 StackView
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // 配置状态标签
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.text = "点击按钮或下拉刷新来测试频率控制"
        stackView.addArrangedSubview(statusLabel)
        
        // 配置数据标签
        dataLabel.textAlignment = .center
        dataLabel.numberOfLines = 0
        dataLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dataLabel.text = "当前数据: 未刷新"
        stackView.addArrangedSubview(dataLabel)
        
        // 配置按钮
        configureButton(refreshButton, title: "手动触发刷新")
        configureButton(timerButton, title: "启动 5 秒轮询")
        configureButton(manualButton, title: "模拟网络请求成功")
        
        // 设置约束
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(button)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    // MARK: - Combine 绑定设置
    
    private func setupBindings() {
        // 设置按钮点击事件
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        timerButton.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
        manualButton.addTarget(self, action: #selector(manualButtonTapped), for: .touchUpInside)
        
        // 配置刷新触发流 - 5秒内只响应一次，在主线程执行
        refreshTrigger
            .throttle(for: .seconds(5), scheduler: RunLoop.main, latest: false) // 5秒内只响应一次
            .receive(on: RunLoop.main) // 确保在主线程执行
            .sink {
                self.performRefresh()
            }
            .store(in: &cancellables)
        
            }
    
    // MARK: - 刷新处理
    
    /// 执行实际的刷新操作
    private func performRefresh() {
        refreshCount += 1
        let currentTime = Date()
        lastRefreshTime = currentTime
        
        // 模拟网络请求获取的数据
        let randomData = "数据 refreshCount) - \(formatTime(currentTime))"
        
        // 更新 UI
        dataLabel.text = "当前数据: \(randomData)"
        statusLabel.text = "刷新成功！\n上次刷新时间: \(formatTime(currentTime))\n5秒内不会重复刷新"
        statusLabel.textColor = .systemGreen
        
        // 结束下拉刷新
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        print("执行刷新操作: \(randomData)")
    }
    
    // MARK: - 事件处理
    
    @objc private func handleRefresh() {
        // 下拉刷新触发
        statusLabel.text = "正在下拉刷新..."
        statusLabel.textColor = .systemBlue
        triggerRefresh()
    }
    
    @objc private func refreshButtonTapped() {
        // 按钮点击触发
        statusLabel.text = "按钮触发刷新..."
        statusLabel.textColor = .systemBlue
        triggerRefresh()
    }
    
    @objc private func timerButtonTapped() {
        // 启动/停止 5秒轮询
        if timer != nil {
            timer?.cancel()
            timer = nil
            timerButton.setTitle("启动 5 秒轮询", for: .normal)
            timerButton.backgroundColor = .systemBlue
            statusLabel.text = "轮询已停止"
            statusLabel.textColor = .systemRed
        } else {
            startTimer()
            timerButton.setTitle("停止 5 秒轮询", for: .normal)
            timerButton.backgroundColor = .systemRed
            statusLabel.text = "轮询已启动，每 5 秒触发一次"
            statusLabel.textColor = .systemGreen
        }
    }
    
    @objc private func manualButtonTapped() {
        // 模拟网络请求成功，触发刷新
        statusLabel.text = "模拟网络请求成功，触发刷新..."
        statusLabel.textColor = .systemBlue
        triggerRefresh()
    }
    
    // MARK: - 辅助方法
    
    /// 触发刷新操作
    private func triggerRefresh() {
        refreshTrigger.send()
    }
    
    /// 启动定时器，每 5 秒触发一次刷新
    private func startTimer() {
        timer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                self?.statusLabel.text = "定时器触发刷新..."
                self?.statusLabel.textColor = .systemBlue
                self?.triggerRefresh()
            }
    }
    
    /// 格式化时间
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
