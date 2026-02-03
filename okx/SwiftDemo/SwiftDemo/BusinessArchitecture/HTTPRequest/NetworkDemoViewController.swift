import UIKit
import SnapKit
import NetworkKit
import Alamofire

/// 网络请求架构演示页面
/// 
/// 展示内容：
/// 1. RESTful API 请求封装
/// 2. 自动 Token 刷新拦截
/// 3. 统一错误处理分类
/// 4. 网络状态实时监听
class NetworkDemoViewController: UIViewController {

    private let tableView = UITableView()
    private var logs: [String] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupReachability()
        addLog("🚀 网络框架演示已就绪")
    }
    
    private func setupUI() {
        title = "NetworkKit 架构演示"
        view.backgroundColor = .white
        
        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.spacing = 10
        headerStack.distribution = .fillEqually
        view.addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let btn1 = createButton(title: "1. 发起 GET 请求 (GitHub)", action: #selector(testFetchGitHub))
        let btn2 = createButton(title: "2. 模拟 401 触发 Token 刷新", action: #selector(testTokenRefresh))
        let btn3 = createButton(title: "3. 模拟网络错误处理", action: #selector(testErrorHandling))
        
        headerStack.addArrangedSubview(btn1)
        headerStack.addArrangedSubview(btn2)
        headerStack.addArrangedSubview(btn3)
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LogCell")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    // MARK: - Actions
    
    /// 测试正常请求
    @objc private func testFetchGitHub() {
        addLog("📡 正在请求 GitHub API...")
        
        // 使用封装的 APIRequest 协议
        let request = GitHubUserRequest(username: "apple")
        
        NetworkClient.shared.request(request) { [weak self] result in
            switch result {
            case .success(let user):
                self?.addLog("✅ 请求成功: \(user.login) - \(user.bio ?? "无简介")")
            case .failure(let error):
                self?.addLog("❌ 请求失败: \(error.localizedDescription)")
            }
        }
    }
    
    /// 测试 Token 刷新
    @objc private func testTokenRefresh() {
        addLog("🔒 模拟发起需要授权的请求...")
        
        // 这里只是演示，实际项目中需要一个会返回 401 的接口
        // 我们的 TokenRefreshInterceptor 会拦截 401 并自动刷新
        addLog("💡 逻辑：拦截器检测到 401 -> 挂起请求 -> 刷新 Token -> 重试原请求")
        
        // 模拟一个请求
        let request = MockAuthRequest()
        NetworkClient.shared.request(request) { [weak self] result in
            // 演示目的，这里可能报错因为 mock 地址不存在
            self?.addLog("ℹ️ Token 刷新流程已触发，详情查看控制台日志")
        }
    }
    
    /// 测试错误处理
    @objc private func testErrorHandling() {
        addLog("⚠️ 测试错误分类映射...")
        
        let request = InvalidURLRequest()
        NetworkClient.shared.request(request) { [weak self] result in
            if case .failure(let error) = result {
                self?.addLog("📌 识别到错误: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Reachability
    
    private func setupReachability() {
        NetworkReachability.shared.statusChangedHandler = { [weak self] status in
            let statusStr: String
            switch status {
            case .reachable(.ethernetOrWiFi): statusStr = "WiFi"
            case .reachable(.cellular): statusStr = "蜂窝网络"
            case .notReachable: statusStr = "无网络 ❌"
            case .unknown: statusStr = "未知"
            }
            self?.addLog("🌐 网络环境变更: \(statusStr)")
        }
        NetworkReachability.shared.startListening()
    }
    
    private func addLog(_ message: String) {
        let time = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        logs.insert("[\(time)] \(message)", at: 0)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NetworkDemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath)
        cell.textLabel?.text = logs[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        return cell
    }
}

// MARK: - Mock API Requests

struct GitHubUser: Decodable {
    let login: String
    let bio: String?
}

struct GitHubUserRequest: APIRequest {
    typealias ResponseDataType = GitHubUser
    
    let username: String
    
    var path: String { "/users/\(username)" }
    var requiresAuth: Bool { false }
}

struct MockAuthRequest: APIRequest {
    typealias ResponseDataType = [String: String]
    var path: String { "/v1/protected/data" }
    var baseURL: String { "https://httpbin.org/status/401" } // 模拟 401
}

struct InvalidURLRequest: APIRequest {
    typealias ResponseDataType = [String: String]
    var path: String { "/invalid path with spaces" }
}

/*
 MARK: - 封装深度解析：iOS 高性能网络框架设计

 1. 为什么选择 Alamofire 作为底层，而不是原生的 URLSession？
    - 链式调用更优雅。
    - 完善的拦截器 (Interceptor) 机制，处理 Token 刷新和公共参数非常方便。
    - 内置的 ServerTrustManager 简化了 SSL Pinning 的实现。
    - 自动化的响应解析 (Decodable) 减少了样板代码。

 2. 拦截器 (Interceptor) 的工作原理？
    - RequestAdapter: 在请求发出前修改请求（如注入 Token、签名）。
    - RequestRetrier: 在请求失败后决定是否重试（如 401 自动刷新 Token 后重试）。

 3. 如何实现 TLS 双向认证？
    - 客户端需要在 URLSessionDelegate 中提供 Identity (包含私钥和证书)。
    - 服务器验证客户端证书的合法性，完成握手。
    - 核心函数：SecPKCS12Import 解析 .p12 文件。

 4. RESTful API 的核心是什么？
    - 资源导向：每一个 URL 代表一种资源。
    - 统一接口：使用 GET, POST, PUT, DELETE 表达语义。
    - 无状态：请求之间不依赖上下文。

 5. 错误分类的重要性？
    - 客户端错误 (4xx, 序列化错误)：开发者需要检查逻辑。
    - 服务端错误 (5xx)：运维需要检查服务。
    - 网络错误 (无网, 超时)：提示用户检查环境。
    - 分类后，可以针对性地做监控告警和用户提示。
*/
