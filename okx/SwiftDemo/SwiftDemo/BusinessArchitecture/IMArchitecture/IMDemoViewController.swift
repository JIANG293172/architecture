import UIKit
import IMKit
import SnapKit

/// IM 架构演示页面
/// 演示如何使用 IMKit 组件进行连接、发送消息及架构解析
class IMDemoViewController: UIViewController {
    
    private let statusLabel = UILabel()
    private let textView = UITextView()
    private let sendButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupIM()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "IM Architecture"
        
        statusLabel.text = "Connection Status: Disconnected"
        statusLabel.textColor = .systemRed
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        textView.isEditable = false
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        sendButton.setTitle("Send Mock Message", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        let infoLabel = UILabel()
        infoLabel.text = "Architecture: Facade + Adapter + Strategy\nHigh Performance IM Design Demo"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .secondaryLabel
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupIM() {
        // 1. 初始化传输层 (Adapter Pattern)
        let transport = MQTTTransport(host: "broker.emqx.io", port: 1883, clientID: "iOS_IM_Demo_\(Int.random(in: 1000...9999))")
        
        // 2. 初始化服务 (Facade Pattern)
        IMService.shared.setup(with: transport)
        IMService.shared.connect()
        
        updateStatus()
    }
    
    private func updateStatus() {
        statusLabel.text = "Connection Status: Connecting..."
        statusLabel.textColor = .systemOrange
        
        // 模拟延迟检查状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.statusLabel.text = "Connection Status: Connected (Mock)"
            self?.statusLabel.textColor = .systemGreen
        }
    }
    
    @objc private func sendMsg() {
        let msg = IMChatMessage(
            seqId: 1001, 
            senderId: "User_A", 
            content: "Hello, this is a test message!", 
            chatId: "Room_001"
        )
        
        IMService.shared.sendMessage(msg, topic: "im/chat/Room_001")
        
        textView.text += "\n[Sent] \(msg.content)"
    }
}
