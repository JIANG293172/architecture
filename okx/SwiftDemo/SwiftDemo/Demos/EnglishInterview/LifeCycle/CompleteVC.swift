import UIKit

/// 完整生命周期演示 VC
/// 涵盖了从 init 到 deinit 的所有关键节点
class CompleteVC: UIViewController {
    
    // MARK: - Properties
    private var vcType: String
    private var customData: String?
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    // MARK: - 1. Initialization (init)
    
    /// 纯代码初始化
    init(vcType: String, customData: String?) {
        self.vcType = vcType
        self.customData = customData
        super.init(nibName: nil, bundle: nil)
        print("🔹 1. init(vcType:customData:) 调用 - 纯代码方式")
    }
    
    /// XIB 初始化 (通常在便利构造器中调用)
    convenience init(nibName: String, data: String) {
        self.init(vcType: "XIB", customData: data)
        print("🔹 1. convenience init(nibName:) 调用 - XIB 方式")
    }
    
    /// Storyboard 初始化
    required init?(coder: NSCoder) {
        self.vcType = "Storyboard"
        self.customData = "Data from Coder"
        super.init(coder: coder)
        print("🔹 1. init(coder:) 调用 - Storyboard 方式")
    }
    
    // MARK: - 2. loadView
    
    override func loadView() {
        // 如果使用纯代码，建议在这里创建 root view
        // 如果使用 XIB/Storyboard，不要重写此方法，除非你想替换掉系统默认创建的 view
        super.loadView()
        print("🔹 2. loadView 调用 - 根视图加载中")
    }
    
    // MARK: - 3. viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        print("🔹 3. viewDidLoad 调用 - 视图已加载到内存，进行一次性初始化")
    }
    
    // MARK: - 4. viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        print("🔹 4. viewWillAppear 调用 - 视图即将显示")
    }
    
    // MARK: - 5. viewWillLayoutSubviews
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("🔹 5. viewWillLayoutSubviews 调用 - 即将开始布局子视图")
    }
    
    // MARK: - 6. viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("🔹 6. viewDidLayoutSubviews 调用 - 子视图布局已完成")
    }
    
    // MARK: - 7. viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runAnimation()
        addNotifications()
        print("🔹 7. viewDidAppear 调用 - 视图已完全显示")
    }
    
    // MARK: - 8. viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseAnimation()
        print("🔹 8. viewWillDisappear 调用 - 视图即将消失")
    }
    
    // MARK: - 9. viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotifications()
        releaseResources()
        print("🔹 9. viewDidDisappear 调用 - 视图已完全消失")
    }
    
    // MARK: - 10. deinit
    
    deinit {
        print("🔹 10. deinit 调用 - 视图控制器已从内存中销毁")
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        view.addSubview(testLabel)
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            testLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        testLabel.text = """
        ViewController Lifecycle Demo
        Type: \(vcType)
        Data: \(customData ?? "None")
        
        Check Console for logs!
        """
    }
    
    private func refreshData() {
        // 模拟数据刷新
        print("📊 数据已刷新")
    }
    
    private func runAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.testLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.testLabel.transform = .identity
            }
        }
        print("📊 动画已执行")
    }
    
    private func pauseAnimation() {
        self.testLabel.layer.removeAllAnimations()
        print("📊 动画已暂停")
    }
    
    private func addNotifications() {
        // 模拟添加通知监听
        print("📊 通知监听已添加")
    }
    
    private func removeNotifications() {
        // 模拟移除通知监听
        print("📊 通知监听已移除")
    }
    
    private func releaseResources() {
        // 取消网络请求或释放大对象
        print("📊 资源已释放")
    }
}
