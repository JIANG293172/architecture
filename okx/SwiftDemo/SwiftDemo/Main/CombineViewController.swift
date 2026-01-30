//
//  Demo5ViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/23.
//

import UIKit
import SwiftUI
import Combine


//一、先明确：属性包装器 / 协议的「归属」（SwiftUI vs Combine）
//关键字 / 协议    归属框架    核心作用    能否脱离对方使用？
//@State    SwiftUI 专属    视图内部私有状态，驱动 UI 刷新    ✅ 完全独立
//@Binding    SwiftUI 专属    父子视图双向绑定外部状态    ✅ 完全独立
//@StateObject    SwiftUI 专属    视图持有 ObservableObject 对象（所有权）    ❌ 依赖 Combine 的 ObservableObject
//@ObservedObject    SwiftUI 专属    监听外部传入的 ObservableObject    ❌ 依赖 Combine 的 ObservableObject
//ObservableObject    Combine 协议    标记类为「可观察对象」，关联 @Published    ❌ SwiftUI 中用它做跨视图数据共享，Combine 可单独用

//@EnvironmentObject    SwiftUI 专属    全局监听环境中的 ObservableObject    ❌ 依赖 Combine 的 ObservableObject
//@AppStorage    SwiftUI 专属    监听 UserDefaults 持久化数据    ✅ 完全独立
//@Environment    SwiftUI 专属    读取 / 监听全局环境值（如主题、尺寸）    ✅ 完全独立
//@Published    Combine 核心    修饰类属性，生成发布者触发事件    ❌ SwiftUI 中用它驱动 UI，Combine 可单独用

// MARK: - 登录视图控制器
class CombineViewController: UIViewController {
    
    internal var hostingController: UIHostingController<LoginView>?
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine + SwiftUI 登录Demo"
        view.backgroundColor = .white
        
        setupSwiftUIView()
        setupBindings()
    }
    
    private func setupSwiftUIView() {
        // 创建SwiftUI登录视图
        let loginView = LoginView(viewModel: viewModel)
        
        // 创建UIHostingController包装SwiftUI视图
        hostingController = UIHostingController(rootView: loginView)
        
        // 添加到当前视图控制器
        guard let hostingController = hostingController else { return }
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // 设置布局
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        // 监听登录状态
        viewModel.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.showLoginSuccess()
                }
            } 
            .store(in: &cancellables)
        
        // 监听错误信息
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if !errorMessage.isEmpty {
                    self?.showError(errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    internal func showLoginSuccess() {
        let alert = UIAlertController(title: "登录成功", message: "欢迎回来！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    internal func showError(_ message: String) {
        let alert = UIAlertController(title: "登录失败", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - 登录设置视图（使用@Binding示例）
struct LoginSettingsView: View {
    // @Binding - 用于父子视图之间的双向绑定
    @Binding var rememberMe: Bool
    @Binding var autoLogin: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("登录设置")
                .font(.system(size: 18, weight: .medium))
            
            HStack {
                Text("记住我")
                Spacer()
                Toggle("", isOn: $rememberMe)
            }
            
            HStack {
                Text("自动登录")
                Spacer()
                Toggle("", isOn: $autoLogin)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - 主题管理器（使用@StateObject示例）
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
}

// MARK: - SwiftUI登录视图
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    // @State - 用于管理视图内部的状态
    @State private var showSettings: Bool = false
    @State private var rememberMe: Bool = false
    @State private var autoLogin: Bool = false
    
    // @StateObject - 用于管理跨多个视图的状态
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 主题切换按钮（@StateObject使用示例）
            HStack {
                Spacer()
                Button(action: {
                    themeManager.toggleTheme()
                }) {
                    Text(themeManager.isDarkMode ? "切换到浅色模式" : "切换到深色模式")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
            }
            
            // 标题
            Text("用户登录")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(themeManager.isDarkMode ? .white : .blue)
            
            // 用户名输入
            VStack(alignment: .leading, spacing: 8) {
                Text("用户名")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
                TextField("请输入用户名", text: $viewModel.username)
                    .padding()
                    .background(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
                    .cornerRadius(8)
                    .autocapitalization(.none)
            }
            
            // 密码输入
            VStack(alignment: .leading, spacing: 8) {
                Text("密码")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
                SecureField("请输入密码", text: $viewModel.password)
                    .padding()
                    .background(themeManager.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
                    .cornerRadius(8)
            }
            
            // 设置按钮（@State使用示例）
            Button(action: {
                showSettings.toggle()
            }) {
                Text("登录设置")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
            
            // 登录设置视图（@Binding使用示例）
            if showSettings {
                LoginSettingsView(rememberMe: $rememberMe, autoLogin: $autoLogin)
            }
            
            // 登录按钮
            Button(action: {
                viewModel.login()
            }) {
                Text("登录")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isLoginButtonEnabled ? Color.blue : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isLoginButtonEnabled)
            
            // 加载状态
            if viewModel.isLoading {
                ProgressView("登录中...")
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
            }
            
            // 登录设置状态显示
            if showSettings {
                Text("记住我: \(rememberMe ? "是" : "否")")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
                Text("自动登录: \(autoLogin ? "是" : "否")")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
            }
            
            Spacer()
        }
        .padding(30)
        .background(themeManager.isDarkMode ? Color.black : Color.white)
        .animation(.easeInOut, value: showSettings)
        .animation(.easeInOut, value: themeManager.isDarkMode)
    }
}

// MARK: - 登录视图模型（MVVM架构）
class LoginViewModel: ObservableObject {
    // MARK: - 输入
    @Published var username: String = ""
    @Published var password: String = ""
    
    // MARK: - 输出
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    
    // MARK: - 计算属性
    var isLoginButtonEnabled: Bool {
        return !username.isEmpty && !password.isEmpty && !isLoading
    }
    
    // MARK: - Combine相关
    private var cancellables = Set<AnyCancellable>()
    private let loginService = LoginService()
    
    // MARK: - PassthroughSubject 示例
    private let loginFlowSubject = PassthroughSubject<LoginFlowEvent, Never>()
    
    // 登录流程事件枚举
    enum LoginFlowEvent {
        case loginStarted
        case loginSucceeded
        case loginFailed(error: String)
        case loginCompleted
    }
    
    init() {
        setupValidations()
    }
    
    // MARK: - 验证设置
    private func setupValidations() {
        // 监听输入变化，清空错误信息
        Publishers.CombineLatest($username, $password)
            .sink {[weak self] _, _ in
                self?.errorMessage = ""
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 登录方法
    func login() {
        isLoading = true
        errorMessage = ""
        
        // 使用登录服务进行登录
        loginService.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                self?.isLoading = false
                
                // 处理错误
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: {[weak self] success in
                if success {
                    self?.isLoggedIn = true
                } else {
                    self?.errorMessage = "用户名或密码错误"
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - 登录服务
class LoginService {
    // 模拟登录API调用
    func login(username: String, password: String) -> AnyPublisher<Bool, Error> {
        // 使用Future创建一个Publisher
        // 面试点：Future是Combine中创建单个值Publisher的常用方式
        return Future<Bool, Error> {promise in
            // 模拟网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                // 简单的验证逻辑
                if username == "admin" && password == "123456" {
                    promise(.success(true))
                } else {
                    // 模拟登录失败
                    promise(.success(false))
                }
            }
        }
        .eraseToAnyPublisher() // 面试点：eraseToAnyPublisher用于类型擦除，隐藏具体实现
    }
}

// MARK: - Combine常用操作符示例
/*
 Combine面试常见问题与解答：
 
 1. 什么是Combine？
    Combine是Apple在iOS 13+推出的响应式编程框架，用于处理异步事件流。
 
 2. Combine的核心组件有哪些？
    - Publisher：发布事件的对象
    - Subscriber：订阅并接收事件的对象
    - Operator：处理和转换事件的操作符
    - Subject：既是Publisher又是Subscriber的对象
 
 3. @Published的作用是什么？
    @Published是Combine提供的属性包装器，用于自动生成Publisher，当属性值变化时发送事件。
 
 4. sink和assign的区别是什么？
    - sink：接收事件并执行闭包，用于执行副作用
    - assign：直接将事件值分配给属性
 
 5. eraseToAnyPublisher的作用是什么？
    用于类型擦除，隐藏具体的Publisher类型，使API更加简洁和稳定。
 
 6. 如何处理错误？
    通过sink的receiveCompletion闭包处理，或使用catch操作符捕获错误。
 
 7. 如何取消订阅？
    将AnyCancellable存储在Set中，当Set销毁时自动取消订阅。
 
 8. Combine与SwiftUI的结合方式？
    使用@ObservedObject、@StateObject等属性包装器，将ViewModel与View绑定。
 
 9. 什么是Subject？常用的Subject有哪些？
    Subject是既是Publisher又是Subscriber的对象，常用的有：
    - PassthroughSubject：直接传递值
    - CurrentValueSubject：存储当前值并在订阅时立即发送
 
 10. 如何处理多个Publisher的组合？
    使用CombineLatest、zip、merge等操作符。
 */

// MARK: - 扩展：常用的Combine操作符示例
extension Publisher {
    // 延迟操作符示例
    func delay(for interval: TimeInterval) -> AnyPublisher<Output, Failure> {
        return self
            .receive(on: DispatchQueue.global())
            .flatMap {value in
                return Future<Output, Failure> {promise in
                    DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
                        promise(.success(value))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    // 重试操作符示例
    func retryWithDelay(maxAttempts: Int, delay: TimeInterval) -> AnyPublisher<Output, Failure> {
        return self
            .catch { error -> AnyPublisher<Output, Failure> in
                if maxAttempts > 1 {
                    return Future<Output, Failure> { promise in
                        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                            // 递归调用
                            self.retryWithDelay(maxAttempts: maxAttempts - 1, delay: delay)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        promise(.failure(error))
                                    }
                                }, receiveValue: { value in
                                    promise(.success(value))
                                })
                        }
                    }
                    .eraseToAnyPublisher()
                } else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - PassthroughSubject 示例
class AuthenticationManager {
    // 创建一个 PassthroughSubject，用于发送认证状态变更事件
    // 泛型参数：Output 类型为 AuthStatus，Failure 类型为 Never（不会发送错误）
    let authStatusSubject = PassthroughSubject<AuthStatus, Never>()
    
    // 认证状态枚举
    enum AuthStatus {
        case unauthenticated
        case authenticating
        case authenticated(userID: String)
        case authenticationFailed(error: String)
    }
    
    // 模拟登录过程
    func login(username: String, password: String) {
        // 发送认证中状态
        authStatusSubject.send(.authenticating)
        
        // 模拟网络延迟
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            if username == "admin" && password == "123456" {
                // 登录成功，发送认证成功状态
                self.authStatusSubject.send(.authenticated(userID: "user_123"))
                // 完成发送
                self.authStatusSubject.send(completion: .finished)
            } else {
                // 登录失败，发送认证失败状态
                self.authStatusSubject.send(.authenticationFailed(error: "用户名或密码错误"))
                // 完成发送
                self.authStatusSubject.send(completion: .finished)
            }
        }
    }
    
    // 模拟登出过程
    func logout() {
        // 发送未认证状态
        authStatusSubject.send(.unauthenticated)
        // 完成发送
        authStatusSubject.send(completion: .finished)
    }
}

// MARK: - 在 LoginViewModel 中添加 PassthroughSubject 示例
extension LoginViewModel {
    // 发送登录流程事件的方法
    private func sendLoginFlowEvent(_ event: LoginFlowEvent) {
        loginFlowSubject.send(event)
    }
    
    // 初始化登录流程事件监听
    private func setupLoginFlowMonitoring() {
        // 监听登录流程事件
        loginFlowSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loginStarted:
                    print("登录流程开始")
                case .loginSucceeded:
                    print("登录流程成功")
                case .loginFailed(let error):
                    print("登录流程失败: \(error)")
                case .loginCompleted:
                    print("登录流程完成")
                }
            }
            .store(in: &cancellables)
    }
    
    // 重写初始化方法，添加登录流程监控
    convenience init(withFlowMonitoring: Bool) {
        self.init()
        if withFlowMonitoring {
            setupLoginFlowMonitoring()
        }
    }
    
    // 重写登录方法，添加流程事件发送
    func loginWithFlowMonitoring() {
        sendLoginFlowEvent(.loginStarted)
        isLoading = true
        errorMessage = ""
        
        // 使用登录服务进行登录
        loginService.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                self?.isLoading = false
                
                // 处理错误
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.sendLoginFlowEvent(.loginFailed(error: error.localizedDescription))
                    self?.sendLoginFlowEvent(.loginCompleted)
                }
            }, receiveValue: {[weak self] success in
                if success {
                    self?.isLoggedIn = true
                    self?.sendLoginFlowEvent(.loginSucceeded)
                } else {
                    self?.errorMessage = "用户名或密码错误"
                    self?.sendLoginFlowEvent(.loginFailed(error: "用户名或密码错误"))
                }
                self?.sendLoginFlowEvent(.loginCompleted)
            })
            .store(in: &cancellables)
    }
}
