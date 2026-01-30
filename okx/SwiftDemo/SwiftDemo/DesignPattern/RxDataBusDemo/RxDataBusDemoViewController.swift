import UIKit
import RxSwift
import RxCocoa
import RxDataBus

/// RxDataBus 跨组件通讯实战演示
class RxDataBusDemoViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RxDataBus 跨组件通讯"
        view.backgroundColor = .systemBackground
        setupUI()
        setupGlobalObserver()
    }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        // 组件 A: 股票价格发送者
        let stockSender = RxStockSenderView()
        stackView.addArrangedSubview(stockSender)
        
        // 组件 B: 股票价格接收者 (1对多演示)
        let stockReceiver = RxStockReceiverView()
        stackView.addArrangedSubview(stockReceiver)
        
        // 组件 C: 登录状态同步器
        let loginSync = RxLoginSyncView()
        stackView.addArrangedSubview(loginSync)
        
        // 全局控制面板
        setupControlPanel()
    }
    
    private func setupControlPanel() {
        let panel = UIView()
        panel.backgroundColor = .secondarySystemBackground
        panel.layer.cornerRadius = 12
        stackView.addArrangedSubview(panel)
        
        let label = UILabel()
        label.text = "Rx 全局总线控制"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(label)
        
        let button = UIButton(type: .system)
        button.setTitle("发送广播 (Topic: Broadcast)", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(button)
        
        button.rx.tap
            .subscribe(onNext: {
                RxDataBus.shared.post(RxDataBusTopics.broadcast, event: "📢 来自 RxDataBus 的紧急通知！")
            })
            .disposed(by: disposeBag)
            
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: panel.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: panel.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            button.centerXAnchor.constraint(equalTo: panel.centerXAnchor)
        ])
    }
    
    private func setupGlobalObserver() {
        // 演示：主容器监听广播
        RxDataBus.shared.observable(for: RxDataBusTopics.broadcast)
            .subscribe(onNext: { msg in
                print("RxContainer received broadcast: \(msg)")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 子组件: 股票价格发送者 (BehaviorRelay 模拟)

class RxStockSenderView: UIView {
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let updateButton = UIButton(type: .system)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .systemBlue.withAlphaComponent(0.05)
        layer.cornerRadius = 12
        
        titleLabel.text = "股票行情源 (组件 A)"
        titleLabel.font = .boldSystemFont(ofSize: 12)
        
        priceLabel.text = "当前价格: --"
        priceLabel.font = .systemFont(ofSize: 16)
        
        updateButton.setTitle("随机更新价格", for: .normal)
        updateButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let newPrice = Double.random(in: 100...200)
                self?.priceLabel.text = String(format: "当前价格: %.2f", newPrice)
                RxDataBus.shared.post(RxDataBusTopics.stockPrice, event: newPrice)
            })
            .disposed(by: disposeBag)
            
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceLabel, updateButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - 子组件: 股票价格接收者

class RxStockReceiverView: UIView {
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .systemGreen.withAlphaComponent(0.05)
        layer.cornerRadius = 12
        
        titleLabel.text = "实时行情监听 (组件 B)"
        titleLabel.font = .boldSystemFont(ofSize: 12)
        
        priceLabel.text = "等待行情数据..."
        priceLabel.textColor = .systemGray
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        RxDataBus.shared.observable(for: RxDataBusTopics.stockPrice)
            .map { String(format: "收到实时价格: %.2f", $0) }
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
            
        // 监听全局广播
        RxDataBus.shared.observable(for: RxDataBusTopics.broadcast)
            .subscribe(onNext: { [weak self] _ in
                self?.layer.borderWidth = 2
                self?.layer.borderColor = UIColor.systemRed.cgColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.layer.borderWidth = 0
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 子组件: 登录状态同步器

class RxLoginSyncView: UIView {
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let toggleButton = UIButton(type: .system)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .systemOrange.withAlphaComponent(0.05)
        layer.cornerRadius = 12
        
        titleLabel.text = "状态同步器 (组件 C)"
        titleLabel.font = .boldSystemFont(ofSize: 12)
        
        statusLabel.text = "登录状态: 未知"
        
        toggleButton.setTitle("切换全局登录状态", for: .normal)
        toggleButton.rx.tap
            .subscribe(onNext: {
                let current = RxDataBus.shared.currentState(for: RxDataBusTopics.userLogin) ?? false
                RxDataBus.shared.sync(RxDataBusTopics.userLogin, state: !current)
            })
            .disposed(by: disposeBag)
            
        let stack = UIStackView(arrangedSubviews: [titleLabel, statusLabel, toggleButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        RxDataBus.shared.stateObservable(for: RxDataBusTopics.userLogin, initialValue: false)
            .map { $0 ? "✅ 已登录 (同步中)" : "❌ 未登录 (同步中)" }
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
