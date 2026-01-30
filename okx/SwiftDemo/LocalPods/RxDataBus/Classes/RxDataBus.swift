import Foundation
import RxSwift
import RxRelay

/// RxDataBus - 基于 RxSwift 的跨组件通讯中间件
public final class RxDataBus {
    
    public static let shared = RxDataBus()
    
    private var subjects: [String: Any] = [:]
    private let lock = NSRecursiveLock()
    
    private init() {}
    
    // MARK: - 事件总线 (瞬时事件 - PublishSubject)
    
    /// 发送一个瞬时事件
    public func post<T>(event: T, topic: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let subject = subjects[topic] as? PublishSubject<T> {
            subject.onNext(event)
        }
    }
    
    /// 订阅一个瞬时事件流
    public func observable<T>(for topic: String) -> Observable<T> {
        lock.lock()
        defer { lock.unlock() }
        
        if let existing = subjects[topic] as? PublishSubject<T> {
            return existing.asObservable()
        } else {
            let subject = PublishSubject<T>()
            subjects[topic] = subject
            return subject.asObservable()
        }
    }
    
    // MARK: - 状态同步 (持久状态 - BehaviorRelay)
    
    /// 同步一个状态
    public func sync<T>(state: T, topic: String) {
        lock.lock()
        defer { lock.unlock() }
        
        if let relay = subjects[topic] as? BehaviorRelay<T> {
            relay.accept(state)
        } else {
            let relay = BehaviorRelay<T>(value: state)
            subjects[topic] = relay
        }
    }
    
    /// 订阅一个状态流 (会立即收到当前值)
    public func stateObservable<T>(for topic: String, initialValue: T) -> Observable<T> {
        lock.lock()
        defer { lock.unlock() }
        
        if let existing = subjects[topic] as? BehaviorRelay<T> {
            return existing.asObservable()
        } else {
            let relay = BehaviorRelay<T>(value: initialValue)
            subjects[topic] = relay
            return relay.asObservable()
        }
    }
    
    /// 获取当前状态值
    public func currentState<T>(for topic: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        return (subjects[topic] as? BehaviorRelay<T>)?.value
    }
}

// MARK: - 强类型扩展

public protocol RxDataBusTopic {
    associatedtype DataType
    var identifier: String { get }
}

public extension RxDataBus {
    
    func post<T: RxDataBusTopic>(_ topic: T, event: T.DataType) {
        post(event: event, topic: topic.identifier)
    }
    
    func observable<T: RxDataBusTopic>(for topic: T) -> Observable<T.DataType> {
        observable(for: topic.identifier)
    }
    
    func sync<T: RxDataBusTopic>(_ topic: T, state: T.DataType) {
        sync(state: state, topic: topic.identifier)
    }
    
    func stateObservable<T: RxDataBusTopic>(for topic: T, initialValue: T.DataType) -> Observable<T.DataType> {
        stateObservable(for: topic.identifier, initialValue: initialValue)
    }
    
    func currentState<T: RxDataBusTopic>(for topic: T) -> T.DataType? {
        currentState(for: topic.identifier)
    }
}
