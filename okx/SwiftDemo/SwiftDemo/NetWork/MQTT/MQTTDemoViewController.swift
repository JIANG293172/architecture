import UIKit
import CocoaMQTT

/// MQTT IM 落地完整演示
class MQTTDemoViewController: UIViewController {
    
    private let logTextView = UITextView()
    private let statusLabel = UILabel()
    private let connectButton = UIButton(type: .system)
    private let sendChatButton = UIButton(type: .system)
    private let sendSystemButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMQTT()
        observeNotifications()
    }
    
    private func setupUI() {
        title = "MQTT IM 落地演示"
        view.backgroundColor = .systemGroupedBackground
        
        statusLabel.text = "状态: 未连接"
        statusLabel.textAlignment = .center
        statusLabel.font = .boldSystemFont(ofSize: 16)
        statusLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 30)
        view.addSubview(statusLabel)
        
        let buttonWidth = (view.frame.width - 60) / 3
        
        connectButton.setTitle("连接 Broker", for: .normal)
        connectButton.backgroundColor = .systemBlue
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.layer.cornerRadius = 8
        connectButton.frame = CGRect(x: 20, y: 140, width: buttonWidth, height: 44)
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
        view.addSubview(connectButton)
        
        sendChatButton.setTitle("模拟聊天", for: .normal)
        sendChatButton.backgroundColor = .systemGreen
        sendChatButton.setTitleColor(.white, for: .normal)
        sendChatButton.layer.cornerRadius = 8
        sendChatButton.frame = CGRect(x: 20 + buttonWidth + 10, y: 140, width: buttonWidth, height: 44)
        sendChatButton.addTarget(self, action: #selector(sendChatTapped), for: .touchUpInside)
        view.addSubview(sendChatButton)
        
        sendSystemButton.setTitle("模拟系统", for: .normal)
        sendSystemButton.backgroundColor = .systemOrange
        sendSystemButton.setTitleColor(.white, for: .normal)
        sendSystemButton.layer.cornerRadius = 8
        sendSystemButton.frame = CGRect(x: 20 + (buttonWidth + 10) * 2, y: 140, width: buttonWidth, height: 44)
        sendSystemButton.addTarget(self, action: #selector(sendSystemTapped), for: .touchUpInside)
        view.addSubview(sendSystemButton)
        
        logTextView.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: view.frame.height - 240)
        logTextView.backgroundColor = .black
        logTextView.textColor = .green
        logTextView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        logTextView.isEditable = false
        logTextView.layer.cornerRadius = 8
        view.addSubview(logTextView)
        
        addLog("🚀 MQTT IM 演示已就绪\n使用策略模式分发消息\n支持自动重连与网络监听")
    }
    
    private func setupMQTT() {
        MQTTManager.shared.onConnectionStatusChange = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .connected:
                    self?.statusLabel.text = "状态: ✅ 已连接"
                    self?.statusLabel.textColor = .systemGreen
                    self?.addLog("✅ MQTT Broker 连接成功")
                case .disconnected:
                    self?.statusLabel.text = "状态: ❌ 已断开"
                    self?.statusLabel.textColor = .systemRed
                    self?.addLog("🔌 MQTT 已断开连接")
                default:
                    self?.statusLabel.text = "状态: ⏳ 正在连接..."
                    self?.statusLabel.textColor = .systemGray
                }
            }
        }
    }
    
    private func observeNotifications() {
        Foundation.NotificationCenter.default.addObserver(forName: .didReceiveIMChatMessage, object: nil, queue: .main) { [weak self] note in
            if let msg = note.object as? IMChatMessage {
                self?.addLog("📩 [收到聊天]: \(msg.senderId): \(msg.content)")
            }
        }
        
        Foundation.NotificationCenter.default.addObserver(forName: .didReceiveIMSystemNotice, object: nil, queue: .main) { [weak self] note in
            if let notice = note.object as? IMSystemNotice {
                self?.addLog("📢 [收到通知]: \(notice.title)\n   内容: \(notice.body)")
            }
        }
    }
    
    @objc private func connectTapped() {
        addLog("⏳ 正在尝试连接公共 Broker...")
        MQTTManager.shared.connect(with: .default)
    }
    
    @objc private func sendChatTapped() {
        let chatMsg = IMChatMessage(
            msgId: UUID().uuidString,
            timestamp: Int64(Date().timeIntervalSince1970),
            senderId: "User_A",
            content: "你好，这是一条通过 MQTT 发送的消息！",
            chatId: "room_101"
        )
        
        if let data = chatMsg.encode() {
            addLog("📤 发送模拟聊天消息...")
            MQTTManager.shared.publish(topic: "im/chat/user_b", data: data)
            
            // 为了演示，本地也分发一次
            MQTTMessageDispatcher.shared.dispatch(CocoaMQTTMessage(topic: "im/chat/user_b", payload: Array(data)))
        }
    }
    
    @objc private func sendSystemTapped() {
        let notice = IMSystemNotice(
            msgId: UUID().uuidString,
            timestamp: Int64(Date().timeIntervalSince1970),
            title: "系统维护通知",
            body: "服务器将于凌晨 2:00 进行例行维护，请知悉。",
            actionUrl: "https://okx.com/notice"
        )
        
        if let data = notice.encode() {
            addLog("📤 发送模拟系统消息...")
            MQTTManager.shared.publish(topic: MQTTTopics.system, data: data)
            
            // 为了演示，本地也分发一次
            MQTTMessageDispatcher.shared.dispatch(CocoaMQTTMessage(topic: MQTTTopics.system, payload: Array(data)))
        }
    }
    
    private func addLog(_ text: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: Date())
        let newLog = "[\(time)] \(text)\n"
        logTextView.text += newLog
        logTextView.scrollRangeToVisible(NSMakeRange(logTextView.text.count - 1, 1))
    }
}
