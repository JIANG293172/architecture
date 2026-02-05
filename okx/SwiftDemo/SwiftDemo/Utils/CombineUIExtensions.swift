import UIKit
import Combine

// MARK: - UIControl + Combine
extension UIControl {
    
    /// 创建一个针对特定 UIControl.Event 的 Publisher
    func publisher(for event: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, event: event)
    }
}

/// 自定义 UIControl Publisher
struct UIControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never 
    let control: Control
    let event: UIControl.Event
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}

/// 自定义 UIControl Subscription
final class UIControlSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control {
    private var subscriber: S?
    private let control: Control
    
    init(subscriber: S, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        subscriber = nil
    }
    
    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

// MARK: - UIButton 快捷操作
extension UIButton {
    /// 模拟 RxSwift 的 button.rx.tap
    var tapPublisher: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

// MARK: - UITextField 快捷操作
extension UITextField {
    /// 模拟 RxSwift 的 textField.rx.text
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}

// MARK: - NotificationCenter 快捷操作
extension NotificationCenter {
    /// 其实系统自带了 NotificationCenter.default.publisher(for: ...)，
    /// 这里只是为了保持链式调用习惯的提示。
}
