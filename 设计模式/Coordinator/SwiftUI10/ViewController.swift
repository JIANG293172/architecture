import UIKit
import Foundation

// ======================== 第一步：定义 Coordinator 核心协议和基类 ========================
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}
    
    // 管理子Coordinator，避免内存泄漏
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// ======================== 第二步：实现业务 VC（你提供的 ViewController 作为首页） ========================
// 首页 VC（基于你提供的代码扩展）
class ViewController: UIViewController {
    // 跳转详情页的回调（通知 Coordinator 处理导航）
    var onTapGotoDetail: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeUI()
    }
    
    // 构建极简首页 UI
    private func setupHomeUI() {
        view.backgroundColor = .white
        title = "首页"
        
        // 1. 标题标签
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 40))
        titleLabel.text = "Coordinator 模式 Demo"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(titleLabel)
        
        // 2. 跳转详情页按钮
        let detailBtn = UIButton(type: .system)
        detailBtn.frame = CGRect(x: 50, y: 200, width: view.bounds.width - 100, height: 50)
        detailBtn.setTitle("跳转到详情页", for: .normal)
        detailBtn.titleLabel?.font = .systemFont(ofSize: 18)
        detailBtn.addTarget(self, action: #selector(detailBtnClicked), for: .touchUpInside)
        view.addSubview(detailBtn)
    }
    
    // 按钮点击事件：仅通知 Coordinator，不处理导航
    @objc private func detailBtnClicked() {
        // 传递测试数据给详情页
        onTapGotoDetail?("这是从首页传递的测试数据")
    }
}

// 详情页 VC
class DetailViewController: UIViewController {
    // 接收首页传递的数据
    private var dataFromHome: String?
    
    // 返回首页的回调
    var onTapBack: (() -> Void)?
    
    // 初始化方法：接收外部传递的数据（依赖注入）
    init(data: String) {
        self.dataFromHome = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailUI()
    }
    
    private func setupDetailUI() {
        view.backgroundColor = .lightGray
        title = "详情页"
        
        // 1. 展示从首页传递的数据
        let dataLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 40))
        dataLabel.text = dataFromHome ?? "无数据"
        dataLabel.textAlignment = .center
        dataLabel.font = .systemFont(ofSize: 16)
        view.addSubview(dataLabel)
        
        // 2. 返回首页按钮
        let backBtn = UIButton(type: .system)
        backBtn.frame = CGRect(x: 50, y: 200, width: view.bounds.width - 100, height: 50)
        backBtn.setTitle("返回首页", for: .normal)
        backBtn.titleLabel?.font = .systemFont(ofSize: 18)
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        view.addSubview(backBtn)
    }
    
    @objc private func backBtnClicked() {
        // 通知 Coordinator 处理返回逻辑
        onTapBack?()
    }
}

// ======================== 第三步：实现业务 Coordinator ========================
// 首页 Coordinator（管理首页+详情页流程）
class HomeCoordinator: BaseCoordinator {
    override func start() {
        // 1. 创建首页 VC（你提供的 ViewController）
        let homeVC = ViewController()
        
        // 2. 绑定首页回调：跳转详情页
        homeVC.onTapGotoDetail = { [weak self] data in
            guard let self = self else { return }
            self.navigateToDetail(with: data)
        }
        
        // 3. 展示首页（Coordinator 掌控导航）
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    // 跳转到详情页的逻辑（Coordinator 专属）
    private func navigateToDetail(with data: String) {
        // 1. 创建详情页 VC（依赖注入传递数据）
        let detailVC = DetailViewController(data: data)
        
        // 2. 绑定详情页回调：返回首页
        detailVC.onTapBack = { [weak self] in
            guard let self = self else { return }
            self.navigationController.popViewController(animated: true)
        }
        
        // 3. 执行导航（VC 中无任何 push 代码）
        navigationController.pushViewController(detailVC, animated: true)
    }
}

// 根 Coordinator（App 全局流程）
class AppCoordinator: BaseCoordinator {
    func startApp() {
        // 启动首页流程
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
}

// ======================== 第四步：配置 App 入口（SceneDelegate/iOS 15+ 可用 AppDelegate） ========================
// SceneDelegate（iOS 13+）
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    var window: UIWindow?
//    private var appCoordinator: AppCoordinator!
//    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        // 1. 创建窗口和根导航控制器
//        let window = UIWindow(windowScene: windowScene)
//        let rootNav = UINavigationController()
//        window.rootViewController = rootNav
//        window.makeKeyAndVisible()
//        self.window = window
//        
//        // 2. 启动 Coordinator 流程
//        appCoordinator = AppCoordinator(navigationController: rootNav)
//        appCoordinator.startApp()
//    }
//}

// 兼容 iOS 15+ 的 AppDelegate（若项目未使用 SceneDelegate）
// @main
// class AppDelegate: UIResponder, UIApplicationDelegate {
//     var window: UIWindow?
//     private var appCoordinator: AppCoordinator!
//
//     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//         // 1. 创建窗口和根导航控制器
//         window = UIWindow(frame: UIScreen.main.bounds)
//         let rootNav = UINavigationController()
//         window?.rootViewController = rootNav
//         window?.makeKeyAndVisible()
//
//         // 2. 启动 Coordinator 流程
//         appCoordinator = AppCoordinator(navigationController: rootNav)
//         appCoordinator.startApp()
//         return true
//     }
// }
