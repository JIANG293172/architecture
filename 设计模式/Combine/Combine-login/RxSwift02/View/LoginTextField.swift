//
//  UIKit+Combine.swift
//  CombineLoginDemo
//

import UIKit
import Combine


class LoginTextField: UITextField {
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    init(placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        setupUI(placeholder: placeholder, isSecure: isSecure)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(placeholder: "", isSecure: false)
    }
    
    private func setupUI(placeholder: String, isSecure: Bool) {
        font = .systemFont(ofSize: 16)
        borderStyle = .none
        self.placeholder = placeholder
        isSecureTextEntry = isSecure
        
        addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
            make.height.equalTo(50)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(66)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    func setValidationState(_ state: ValidationLabel.ValidationState) {
        switch state {
        case .normal:
            borderView.layer.borderColor = UIColor.systemGray4.cgColor
        case .valid:
            borderView.layer.borderColor = UIColor.systemGreen.cgColor
        case .invalid:
            borderView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}




// UITextField Combine 扩展
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    var returnPublisher: AnyPublisher<Void, Never> {
        return delegateProxy.returnSubject.eraseToAnyPublisher()
    }
    
    private var delegateProxy: TextFieldDelegateProxy {
        if let proxy = objc_getAssociatedObject(self, &TextFieldDelegateProxy.key) as? TextFieldDelegateProxy {
            return proxy
        }
        let proxy = TextFieldDelegateProxy()
        objc_setAssociatedObject(self, &TextFieldDelegateProxy.key, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        delegate = proxy
        return proxy
    }
}

private class TextFieldDelegateProxy: NSObject, UITextFieldDelegate {
    static var key = "TextFieldDelegateProxy"
    
    let returnSubject = PassthroughSubject<Void, Never>()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnSubject.send()
        return true
    }
}

// UIButton Combine 扩展
extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
    }
    
    private func controlEventPublisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        PublisherControlTarget(self, controlEvents: event)
            .eraseToAnyPublisher()
    }
}

private struct PublisherControlTarget: Publisher {
    typealias Output = Void
    typealias Failure = Never
    
    private let control: UIControl
    private let controlEvents: UIControl.Event
    
    init(_ control: UIControl, controlEvents: UIControl.Event) {
        self.control = control
        self.controlEvents = controlEvents
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
        let subscription = ControlTargetSubscription(
            subscriber: subscriber,
            control: control,
            event: controlEvents
        )
        subscriber.receive(subscription: subscription)
    }
}

private final class ControlTargetSubscription<S: Subscriber>: Subscription where S.Input == Void {
    private var subscriber: S?
    private weak var control: UIControl?
    private let event: UIControl.Event
    
    init(subscriber: S, control: UIControl, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // 不需要实现，因为 UI 事件是无限的
    }
    
    func cancel() {
        subscriber = nil
        control?.removeTarget(self, action: #selector(eventHandler), for: event)
    }
    
    @objc private func eventHandler() {
        _ = subscriber?.receive(())
    }
}
