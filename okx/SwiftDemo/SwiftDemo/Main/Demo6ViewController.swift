//
//  Demo6ViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/23.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxRelay
import Alamofire

// MARK: - RxSwift + SwiftUI 示例视图控制器
class Demo6ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = Demo6ViewModel()
    private var hostingController: UIHostingController<Demo6SwiftUIView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RxSwift + SwiftUI 示例"
        view.backgroundColor = .white
        
        setupSwiftUIView()
        setupBindings()
        setupNavigationBar()
    }
    
    private func setupSwiftUIView() {
        let swiftUIView = Demo6SwiftUIView(viewModel: viewModel)
        hostingController = UIHostingController(rootView: swiftUIView)
        
        guard let hostingController = hostingController else { return }
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        // 监听错误信息
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                if !errorMessage.isEmpty {
                    self?.showError(errorMessage)
                }
            })
            .disposed(by: disposeBag)
        
        // 监听加载状态
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "重置",
            style: .plain,
            target: self,
            action: #selector(resetAction)
        )
    }
    
    @objc private func resetAction() {
        viewModel.reset()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoading() {
        // 这里可以实现加载指示器
        print("显示加载指示器")
    }
    
    private func hideLoading() {
        // 这里可以隐藏加载指示器
        print("隐藏加载指示器")
    }
}

// MARK: - RxSwift 视图模型
class Demo6ViewModel {
    
    // MARK: - 输入
    let username = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    let submitButtonTapped = PublishSubject<Void>()
    
    // MARK: - 输出
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String>(value: "")
    let isSubmitButtonEnabled: Driver<Bool>
    let validationResults: Driver<[ValidationResult]>
    
    // MARK: - 其他
    private let disposeBag = DisposeBag()
    private let apiService = ApiService()
    
    init() {
        // 验证结果
        let usernameValidation = username
            .map { $0.count >= 3 }
            .map { $0 ? ValidationResult.success("用户名有效") : ValidationResult.error("用户名至少3个字符") }
            .asDriver(onErrorJustReturn: .error("验证失败"))
        
        let passwordValidation = password
            .map { $0.count >= 6 }
            .map { $0 ? ValidationResult.success("密码有效") : ValidationResult.error("密码至少6个字符") }
            .asDriver(onErrorJustReturn: .error("验证失败"))
        
        let emailValidation = email
            .map { Demo6ViewModel.isValidEmail($0) }
            .map { $0 ? ValidationResult.success("邮箱有效") : ValidationResult.error("邮箱格式不正确") }
            .asDriver(onErrorJustReturn: .error("验证失败"))
        
        // 组合验证结果
        validationResults = Driver.combineLatest(
            usernameValidation,
            passwordValidation,
            emailValidation
        ) { [$0, $1, $2] }
        
        // 提交按钮启用状态
        isSubmitButtonEnabled = Driver.combineLatest(
            usernameValidation,
            passwordValidation,
            emailValidation,
            isLoading.asDriver()
        ) { usernameValid, passwordValid, emailValid, loading in
            switch (usernameValid, passwordValid, emailValid) {
            case (.success, .success, .success):
                return !loading
            default:
                return false
            }
        }
        
        // 处理提交事件
        setupSubmitHandling()
    }
    
    private func setupSubmitHandling() {
        submitButtonTapped
            .withLatestFrom(isSubmitButtonEnabled)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.submitForm()
            })
            .disposed(by: disposeBag)
    }
    
    private func submitForm() {
        isLoading.accept(true)
        errorMessage.accept("")
         
        let username = self.username.value
        let password = self.password.value
        let email = self.email.value
        
        // 模拟API请求
        apiService.register(username: username, password: password, email: email)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.isLoading.accept(false)
                if result {
                    self?.errorMessage.accept("注册成功！")
                } else {
                    self?.errorMessage.accept("注册失败，请重试")
                }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func reset() {
        username.accept("")
        password.accept("")
        email.accept("")
        errorMessage.accept("")
        isLoading.accept(false)
    }
}

// MARK: - 验证结果
enum ValidationResult {
    case success(String)
    case error(String)
}

// MARK: - API服务
class ApiService {
    
    // 模拟注册API
    func register(username: String, password: String, email: String) -> Observable<Bool> {
        return Observable.create { observer in
            // 模拟网络延迟
            let disposable = Disposables.create()
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                // 简单的验证逻辑
                if username == "admin" && password == "123456" && email.contains("@") {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            
            return disposable
        }
    }
    
    // 模拟网络请求（带错误处理）
    func fetchData() -> Observable<[String]> {
        return Observable.create { observer in
            let disposable = Disposables.create()
            
            // 模拟网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                // 模拟成功
                observer.onNext(["数据1", "数据2", "数据3"])
                observer.onCompleted()
            }
            
            return disposable
        }
    }
    
    // 模拟错误的网络请求
    func fetchDataWithError() -> Observable<[String]> {
        return Observable.create { observer in
            let disposable = Disposables.create()
            
            // 模拟网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                // 模拟错误
                observer.onError(NSError(domain: "ApiError", code: 500, userInfo: [NSLocalizedDescriptionKey: "网络请求失败"]))
            }
            
            return disposable
        }
    }
}

// MARK: - SwiftUI 视图
struct Demo6SwiftUIView: View {
    
    // RxSwift 视图模型
    private let viewModel: Demo6ViewModel
    
    // SwiftUI 状态
    @State private var showAdvancedOptions = false
    @State private var selectedGender = Gender.male
    
    // 性别枚举
    enum Gender: String, CaseIterable, Identifiable {
        case male = "男"
        case female = "女"
        case other = "其他"
        
        var id: String { self.rawValue }
    }
    
    init(viewModel: Demo6ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 标题
                Text("RxSwift + SwiftUI 表单示例")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.blue)
                
                // 用户名输入
                VStack(alignment: .leading, spacing: 8) {
                    Text("用户名")
                        .font(.system(size: 16, weight: .medium))
                    TextField("请输入用户名", text: Binding(
                        get: { viewModel.username.value },
                        set: { viewModel.username.accept($0) }
                    ))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                }
                
                // 密码输入
                VStack(alignment: .leading, spacing: 8) {
                    Text("密码")
                        .font(.system(size: 16, weight: .medium))
                    SecureField("请输入密码", text: Binding(
                        get: { viewModel.password.value },
                        set: { viewModel.password.accept($0) }
                    ))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // 邮箱输入
                VStack(alignment: .leading, spacing: 8) {
                    Text("邮箱")
                        .font(.system(size: 16, weight: .medium))
                    TextField("请输入邮箱", text: Binding(
                        get: { viewModel.email.value },
                        set: { viewModel.email.accept($0) }
                    ))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                }
                
                // 高级选项
                DisclosureGroup("高级选项", isExpanded: $showAdvancedOptions) {
                    // 性别选择
                    VStack(alignment: .leading, spacing: 8) {
                        Text("性别")
                            .font(.system(size: 16, weight: .medium))
                        Picker("性别", selection: $selectedGender) {
                            ForEach(Gender.allCases) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // RxSwift 操作符示例
                    RxSwiftOperatorsDemoView()
                }
                
                // 验证结果
                ValidationResultsView(viewModel: viewModel)
                
                // 提交按钮
                Button(action: {
                    viewModel.submitButtonTapped.onNext(())
                }) {
                    Text("提交")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid() ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!isFormValid())
                
                // 加载指示器
                if viewModel.isLoading.value {
                    ProgressView("提交中...")
                        .padding()
                }
            }
            .padding(30)
        }
    }
    
    // 表单验证辅助方法
    private func isFormValid() -> Bool {
        let isUsernameValid = viewModel.username.value.count >= 3
        let isPasswordValid = viewModel.password.value.count >= 6
        let isEmailValid = isValidEmail(viewModel.email.value)
        let isNotLoading = !viewModel.isLoading.value
        return isUsernameValid && isPasswordValid && isEmailValid && isNotLoading
    }
    
    // 邮箱验证辅助方法
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - 验证结果视图
struct ValidationResultsView: View {
    private let viewModel: Demo6ViewModel
    
    init(viewModel: Demo6ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("验证结果")
                .font(.system(size: 16, weight: .medium))
            Text("用户名：" + (viewModel.username.value.count >= 3 ? "有效" : "至少3个字符"))
                .font(.system(size: 14))
                .foregroundColor(viewModel.username.value.count >= 3 ? .green : .red)
            Text("密码：" + (viewModel.password.value.count >= 6 ? "有效" : "至少6个字符"))
                .font(.system(size: 14))
                .foregroundColor(viewModel.password.value.count >= 6 ? .green : .red)
            Text("邮箱：" + (isValidEmail(viewModel.email.value) ? "有效" : "格式不正确"))
                .font(.system(size: 14))
                .foregroundColor(isValidEmail(viewModel.email.value) ? .green : .red)
        }
        .padding(.top, 10)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - RxSwift 操作符示例视图
struct RxSwiftOperatorsDemoView: View {
    
    // 操作符示例
    private let operators = [
        "map": "将序列中的每个元素转换为另一个元素",
        "flatMap": "将序列中的每个元素转换为一个序列，然后将这些序列合并",
        "filter": "过滤掉不符合条件的元素",
        "debounce": "在指定时间内如果没有新元素，则发出最后一个元素",
        "throttle": "在指定时间内只发出第一个元素",
        "distinctUntilChanged": "只发出与前一个元素不同的元素",
        "zip": "将多个序列组合成一个序列",
        "combineLatest": "将多个序列的最新元素组合成一个元素",
        "withLatestFrom": "使用另一个序列的最新元素",
        "catch": "捕获错误并返回一个默认值或新序列",
        "retry": "在发生错误时重试序列",
        "timeout": "在指定时间内如果没有元素发出，则产生错误"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("RxSwift 操作符示例")
                .font(.system(size: 16, weight: .medium))
            
            ForEach(operators.sorted(by: { $0.key < $1.key }), id: \.key) {
                key, value in
                VStack(alignment: .leading, spacing: 4) {
                    Text(key)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                    Text(value)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

// MARK: - Swift 常见面试知识点
/*
 Swift 常见面试知识点：
 
 1. Swift 特性：
    - 值类型 vs 引用类型
    - 可选类型和可选链
    - 闭包和尾随闭包
    - 泛型
    - 协议和扩展
    - 错误处理
    - 内存管理（ARC）
    - 方法调度
 
 2. RxSwift 相关：
    - Observable、Observer、Subject
    - DisposeBag 和内存管理
    - Scheduler（调度器）
    - 操作符的使用场景
    - 错误处理策略
    - 响应式编程思想
 
 3. SwiftUI 相关：
    - 声明式UI
    - 状态管理（@State、@Binding、@ObservedObject、@EnvironmentObject）
    - 视图生命周期
    - 动画和过渡
    - 布局系统
 
 4. 性能优化：
    - 懒加载
    - 内存优化
    - 计算属性 vs 存储属性
    - 循环引用避免
    - 图片加载优化
 
 5. 设计模式：
    - MVVM
    - 单例模式
    - 工厂模式
    - 观察者模式
    - 装饰器模式
 
 6. 网络请求：
    - URLSession
    - Alamofire
    - 缓存策略
    - 重试机制
    - 并发处理
 */

// MARK: - 设计模式示例
// 单例模式示例
class AppManager {
    static let shared = AppManager()
    private init() {}
    
    var userToken: String?
    var isLoggedIn: Bool {
        return userToken != nil
    }
}

// 观察者模式示例（使用RxSwift）
class NotificationCenter {
    let notificationSubject = PublishSubject<String>()
    
    func postNotification(_ message: String) {
        notificationSubject.onNext(message)
    }
    
    func subscribeToNotifications() -> Observable<String> {
        return notificationSubject
    }
}

// 工厂模式示例
protocol Animal {
    func makeSound()
}

class Dog: Animal {
    func makeSound() {
        print("Woof!")
    }
}

class Cat: Animal {
    func makeSound() {
        print("Meow!")
    }
}

class AnimalFactory {
    static func createAnimal(type: String) -> Animal? {
        switch type {
        case "dog":
            return Dog()
        case "cat":
            return Cat()
        default:
            return nil
        }
    }
}

// MARK: - 内存管理示例
class Parent {
    var child: Child?
    deinit {
        print("Parent deinitialized")
    }
}

class Child {
    weak var parent: Parent? // 使用weak避免循环引用
    deinit {
        print("Child deinitialized")
    }
}

// MARK: - 泛型示例
class Stack<T> {
    private var elements: [T] = []
    
    func push(_ element: T) {
        elements.append(element)
    }
    
    func pop() -> T? {
        return elements.popLast()
    }
    
    func peek() -> T? {
        return elements.last
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
}

// MARK: - 协议和扩展示例
protocol NamedIdentifiable {
    var id: String { get }
    var name: String { get set }
}

extension NamedIdentifiable {
    func displayInfo() -> String {
        return "ID: \(id), Name: \(name)"
    }
}

class User: NamedIdentifiable {
    let id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension User {
    func greet() -> String {
        return "Hello, \(name)!"
    }
}

// MARK: - 错误处理示例
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Int)
    case parsingError
    case unknownError
}

class NetworkService {
    func fetchData(urlString: String) throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // 模拟网络请求
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: Data?
        var responseError: Error?
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                responseError = error
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                responseError = NetworkError.requestFailed(httpResponse.statusCode)
                return
            }
            
            responseData = data
        }.resume()
        
        semaphore.wait()
        
        if let error = responseError {
            throw error
        }
        
        guard let data = responseData else {
            throw NetworkError.unknownError
        }
        
        return data
    }
    
    // 使用do-catch处理错误
    func processData() {
        do {
            let data = try fetchData(urlString: "https://api.example.com/data")
            print("获取数据成功: \(data.count) bytes")
        } catch NetworkError.invalidURL {
            print("无效的URL")
        } catch NetworkError.requestFailed(let statusCode) {
            print("请求失败，状态码: \(statusCode)")
        } catch NetworkError.parsingError {
            print("解析错误")
        } catch {
            print("未知错误: \(error)")
        }
    }
}

// MARK: - 并发处理示例
class ConcurrencyDemo {
    // 使用DispatchQueue
    func demoDispatchQueue() {
        // 主线程
        DispatchQueue.main.async {
            print("在主线程执行")
        }
        
        // 全局队列（并发）
        DispatchQueue.global(qos: .userInitiated).async {
            print("在全局队列执行")
            
            // 回到主线程
            DispatchQueue.main.async {
                print("从全局队列回到主线程")
            }
        }
    }
    
    // 使用OperationQueue
    func demoOperationQueue() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2 // 限制并发数
        
        let operation1 = BlockOperation {
            print("操作1执行")
            Thread.sleep(forTimeInterval: 1)
        }
        
        let operation2 = BlockOperation {
            print("操作2执行")
            Thread.sleep(forTimeInterval: 1)
        }
        
        let operation3 = BlockOperation {
            print("操作3执行")
        }
        
        operation3.addDependency(operation1) // 操作3依赖于操作1
        
        queue.addOperations([operation1, operation2, operation3], waitUntilFinished: false)
    }
}

// MARK: - 计算属性和存储属性示例
class Circle {
    // 存储属性
    var radius: Double
    
    // 计算属性
    var area: Double {
        get {
            return Double.pi * radius * radius
        }
        set {
            radius = sqrt(newValue / Double.pi)
        }
    }
    
    // 懒加载属性
    lazy var lazyDescription: String = {
        return "半径为 \(radius) 的圆"
    }()
    
    init(radius: Double) {
        self.radius = radius
    }
}

// MARK: - 方法调度示例
class BaseClass {
    func instanceMethod() {
        print("BaseClass instanceMethod")
    }
    
    class func classMethod() {
        print("BaseClass classMethod")
    }
    
    static func staticMethod() {
        print("BaseClass staticMethod")
    }
}

class SubClass: BaseClass {
    override func instanceMethod() {
        print("SubClass instanceMethod")
    }
    
    override class func classMethod() {
        print("SubClass classMethod")
    }
    
    // 注意：static方法不能被重写，这里是定义一个新的静态方法
    // 它会隐藏父类的staticMethod，但不是重写
//    static func staticMethod() {
//        print("SubClass staticMethod")
//    }
}

// MARK: - Combine框架示例（与RxSwift对比）
import Combine

class CombineDemo {
    private var cancellables = Set<AnyCancellable>()
    
    func demoPublishers() {
        // 创建一个发布者
        let publisher = Just("Hello, Combine!")
        
        // 订阅
        publisher
            .sink(receiveCompletion: { completion in
                print("完成: \(completion)")
            }, receiveValue: { value in
                print("收到值: \(value)")
            })
            .store(in: &cancellables)
        
        // 使用Future（类似RxSwift的Observable.create）
        let future = Future<String, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success("Future 完成"))
            }
        }
        
        future
            .sink(receiveCompletion: { completion in
                print("Future 完成: \(completion)")
            }, receiveValue: { value in
                print("Future 收到值: \(value)")
            })
            .store(in: &cancellables)
    }
}

// MARK: - 更多设计模式示例
// 装饰器模式示例
protocol Coffee {
    func cost() -> Double
    func description() -> String
}

class SimpleCoffee: Coffee {
    func cost() -> Double {
        return 5.0
    }
    
    func description() -> String {
        return "简单咖啡"
    }
}

class CoffeeDecorator: Coffee {
    private let coffee: Coffee
    
    init(coffee: Coffee) {
        self.coffee = coffee
    }
    
    func cost() -> Double {
        return coffee.cost()
    }
    
    func description() -> String {
        return coffee.description()
    }
}

class MilkDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 1.5
    }
    
    override func description() -> String {
        return super.description() + ", 加牛奶"
    }
}

class SugarDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 0.5
    }
    
    override func description() -> String {
        return super.description() + ", 加糖"
    }
}

// 策略模式示例
protocol PaymentStrategy {
    func pay(amount: Double) -> Bool
}

class CreditCardPayment: PaymentStrategy {
    private let cardNumber: String
    
    init(cardNumber: String) {
        self.cardNumber = cardNumber
    }
    
    func pay(amount: Double) -> Bool {
        print("使用信用卡 \(cardNumber) 支付 \(amount) 元")
        return true
    }
}

class AlipayPayment: PaymentStrategy {
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func pay(amount: Double) -> Bool {
        print("使用支付宝 \(userId) 支付 \(amount) 元")
        return true
    }
}

class PaymentContext {
    private var strategy: PaymentStrategy
    
    init(strategy: PaymentStrategy) {
        self.strategy = strategy
    }
    
    func setStrategy(strategy: PaymentStrategy) {
        self.strategy = strategy
    }
    
    func executePayment(amount: Double) -> Bool {
        return strategy.pay(amount: amount)
    }
}
