import UIKit
import PaymentKit // 引入本地 Pod

class PayDemoViewController: UIViewController {
    
    private let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerPaymentChannels()
    }
    
    private func setupUI() {
        title = "支付架构演示"
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        let aliBtn = createButton(title: "支付宝支付", color: .systemBlue, action: #selector(payWithAli))
        let wxBtn = createButton(title: "微信支付", color: .systemGreen, action: #selector(payWithWeChat))
        
        statusLabel.text = "等待支付..."
        statusLabel.textColor = .gray
        
        stackView.addArrangedSubview(aliBtn)
        stackView.addArrangedSubview(wxBtn)
        stackView.addArrangedSubview(statusLabel)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
    
    // MARK: - 核心逻辑
    
    private func registerPaymentChannels() {
        // 在业务启动或使用前注册渠道（符合开闭原则）
        PaymentManager.shared.register(channel: AliPayChannel())
        PaymentManager.shared.register(channel: WeChatPayChannel())
    }
    
    @objc private func payWithAli() {
        startPay(method: .aliPay)
    }
    
    @objc private func payWithWeChat() {
        startPay(method: .weChatPay)
    }
    
    private func startPay(method: PaymentMethod) {
        statusLabel.text = "正在发起 \(method.rawValue)..."
        
        // 1. 模拟从后端获取支付参数
        let order = PaymentOrder(
            orderId: "ORDER_\(Int(Date().timeIntervalSince1970))",
            amount: 0.01,
            title: "测试商品",
            payToken: "mock_order_string_from_server"
        )
        
        // 2. 调用统一支付接口
        PaymentManager.shared.startPay(method: method, order: order) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let id):
                    self?.statusLabel.text = "✅ 支付成功！订单号: \(id)"
                    self?.statusLabel.textColor = .systemGreen
                case .failure(let error):
                    self?.statusLabel.text = "❌ 支付失败: \(error.localizedDescription)"
                    self?.statusLabel.textColor = .systemRed
                case .userCancelled:
                    self?.statusLabel.text = "⚠️ 用户取消支付"
                    self?.statusLabel.textColor = .systemOrange
                }
            }
        }
    }
}
