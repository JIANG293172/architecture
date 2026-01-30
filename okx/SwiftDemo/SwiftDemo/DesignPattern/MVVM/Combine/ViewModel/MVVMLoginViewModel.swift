import Foundation
import Combine

/// 登录视图模型 - 深度集成 Combine 与异步任务
class MVVMLoginViewModel: ObservableObject {
    
    // MARK: - Input (View -> ViewModel)
    @Published var username = ""
    @Published var password = ""
    
    // MARK: - Output (ViewModel -> View)
    @Published private(set) var isLoginEnabled = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var loginUser: MVVMLoginUser?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    // MARK: - Combine 原理解析示例
    
    /// 1. 基础绑定与操作符 (Combine Operator)
    private func setupBindings() {
        // Combine 的核心三要素：Publisher (发布者), Operator (操作符), Subscriber (订阅者)
        
        // combineLatest: 将多个 Publisher 的最新值合并
        Publishers.CombineLatest($username, $password)
            .map { username, password in
                // 简单的登录校验逻辑
                return username.count >= 3 && password.count >= 6
            }
            .assign(to: &$isLoginEnabled) // 直接将结果绑定到输出属性
    }
    
    // MARK: - API 演示场景
    
    /// 2. Future 的使用 (单次异步任务包装)
    /// 原理：Future 是一个特殊的 Publisher，它会产生单个值然后结束，或者失败。适用于包装传统的回调。
    func loginWithFuture() {
        isLoading = true
        errorMessage = nil
        
        performLoginFuture(user: username, pass: password)
            .receive(on: RunLoop.main) // 确保在主线程更新 UI
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.loginUser = user
                print("Future 登录成功: \(user.username)")
            }
            .store(in: &cancellables)
    }
    
    private func performLoginFuture(user: String, pass: String) -> Future<MVVMLoginUser, LoginError> {
        return Future { promise in
            // 模拟异步请求
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                if user == "admin" && pass == "123456" {
                    let mockUser = MVVMLoginUser(id: "1", username: "超级管理员", token: "token_xyz", lastLogin: Date())
                    promise(.success(mockUser))
                } else {
                    promise(.failure(.invalidCredentials))
                }
            }
        }
    }
    
    /// 3. Task 与 Combine 的集成 (Swift Concurrency)
    /// 原理：使用 Task 启动异步任务，并结合 @MainActor 自动主线程分发。
    func loginWithTask() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // 模拟异步等待
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                if username == "admin" && password == "123456" {
                    let mockUser = MVVMLoginUser(id: "1", username: "超级管理员(Task)", token: "token_task", lastLogin: Date())
                    await MainActor.run {
                        self.loginUser = mockUser
                        self.isLoading = false
                    }
                } else {
                    throw LoginError.invalidCredentials
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 4. 更多常用 Combine API 演示
    func runCommonCombineDemos() {
        // Just: 立即发送一个值
        Just("Combine Start")
            .sink { print($0) }
            .store(in: &cancellables)
        
        // Timer Publisher
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .prefix(3) // 只取前三次
            .sink { print("Timer: \($0)") }
            .store(in: &cancellables)
        
        // PassthroughSubject: 手动发送事件
        let subject = PassthroughSubject<String, Never>()
        subject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // 防抖
            .sink { print("Debounced Subject: \($0)") }
            .store(in: &cancellables)
        
        subject.send("Event 1")
        subject.send("Event 2")
    }
}
