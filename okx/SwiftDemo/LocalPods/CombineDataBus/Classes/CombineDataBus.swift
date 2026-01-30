import Foundation
import Combine

/// CombineDataBus - 跨组件数据同步与通讯中间件
/// 这是一个完全业务无关的组件，仅依赖 Foundation 和 Combine
public final class CombineDataBus {
    
    /// 单例访问点
    public static let shared = CombineDataBus()
    
    /// 存储所有的 Subject，按 Topic 分组
    private var subjects: [String: Any] = [:]
    private let lock = NSRecursiveLock()
    
    private init() {}
    
    // MARK: - 事件总线 (Transient Events - PassthroughSubject)
    
    /// 发送一个瞬时事件 (类似 NotificationCenter)
    /// - Parameters:
    ///   - event: 事件对象
    ///   - topic: 主题标识符
    public func post<T>(event: T, topic: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let subject = subjects[topic] as? PassthroughSubject<T, Never> {
            subject.send(event)
        }
    }
    
    /// 订阅一个瞬时事件流
    /// - Parameter topic: 主题标识符
    /// - Returns: AnyPublisher
    public func publisher<T>(for topic: String, type: T.Type = T.self) -> AnyPublisher<T, Never> {
        lock.lock()
        defer { lock.unlock() }
        
        let subject: PassthroughSubject<T, Never>
        if let existing = subjects[topic] as? PassthroughSubject<T, Never> {
            subject = existing
        } else {
            subject = PassthroughSubject<T, Never>()
            subjects[topic] = subject
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - 状态同步 (Sticky State - CurrentValueSubject)
    
    /// 更新并同步一个持久化状态
    /// - Parameters:
    ///   - state: 状态对象
    ///   - topic: 主题标识符
    public func sync<T>(state: T, topic: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let subject = subjects[topic] as? CurrentValueSubject<T, Never> {
            subject.send(state)
        } else {
            let subject = CurrentValueSubject<T, Never>(state)
            subjects[topic] = subject
        }
    }
    
    /// 订阅一个持久化状态流 (订阅时会立即收到当前值)
    /// - Parameters:
    ///   - topic: 主题标识符
    ///   - initialValue: 如果主题尚未创建，提供的初始值
    /// - Returns: AnyPublisher
    public func statePublisher<T>(for topic: String, initialValue: T) -> AnyPublisher<T, Never> {
        lock.lock()
        defer { lock.unlock() }
        
        let subject: CurrentValueSubject<T, Never>
        if let existing = subjects[topic] as? CurrentValueSubject<T, Never> {
            subject = existing
        } else {
            subject = CurrentValueSubject<T, Never>(initialValue)
            subjects[topic] = subject
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    /// 获取当前状态值 (非响应式获取)
    public func currentState<T>(for topic: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        return (subjects[topic] as? CurrentValueSubject<T, Never>)?.value
    }
}

// MARK: - 强类型扩展支持 (推荐用法)

/// 定义此协议以支持强类型 Topic
public protocol DataBusTopic {
    associatedtype DataType
    var identifier: String { get }
}

public extension CombineDataBus {
    
    /// 使用强类型 Topic 发送事件
    func post<T: DataBusTopic>(_ topic: T, event: T.DataType) {
        post(event: event, topic: topic.identifier)
    }
    
    /// 使用强类型 Topic 获取发布者
    func publisher<T: DataBusTopic>(for topic: T) -> AnyPublisher<T.DataType, Never> {
        publisher(for: topic.identifier, type: T.DataType.self)
    }
    
    /// 使用强类型 Topic 同步状态
    func sync<T: DataBusTopic>(_ topic: T, state: T.DataType) {
        sync(state: state, topic: topic.identifier)
    }
    
    /// 使用强类型 Topic 获取状态发布者
    func statePublisher<T: DataBusTopic>(for topic: T, initialValue: T.DataType) -> AnyPublisher<T.DataType, Never> {
        statePublisher(for: topic.identifier, initialValue: initialValue)
    }
    
    /// 使用强类型 Topic 获取当前状态
    func currentState<T: DataBusTopic>(for topic: T) -> T.DataType? {
        currentState(for: topic.identifier)
    }
}
