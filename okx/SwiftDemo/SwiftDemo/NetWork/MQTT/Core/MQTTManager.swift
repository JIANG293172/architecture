import Foundation
import CocoaMQTT
import Network

/// MQTT 管理中心 - 负责连接生命周期、订阅管理、心跳与重连
class MQTTManager: NSObject {
    static let shared = MQTTManager()
    
    private var mqtt: CocoaMQTT?
    private var config: MQTTConfig = .default
    private let reachability = NWPathMonitor()
    
    // 状态回调
    var onConnectionStatusChange: ((CocoaMQTTConnState) -> Void)?
    var onMessageReceived: ((CocoaMQTTMessage) -> Void)?
    
    // 重连机制
    private var retryCount = 0
    private let maxRetryCount = 5
    private var isConnecting = false
    
    private override init() {
        super.init()
        setupReachability()
    }
    
    /// 初始化并连接
    func connect(with config: MQTTConfig) {
        self.config = config
        self.isConnecting = true
        
        let clientID = config.clientID
        mqtt = CocoaMQTT(clientID: clientID, host: config.host, port: config.port)
        mqtt?.keepAlive = config.keepAlive
        mqtt?.username = config.username
        mqtt?.password = config.password
        mqtt?.cleanSession = config.cleanSession
        mqtt?.delegate = self
        
        _ = mqtt?.connect()
    }
    
    func disconnect() {
        mqtt?.disconnect()
        isConnecting = false
    }
    
    /// 订阅主题
    func subscribe(topic: String, qos: CocoaMQTTQoS = .qos1) {
        mqtt?.subscribe(topic, qos: qos)
    }
    
    /// 发布消息
    func publish(topic: String, message: String, qos: CocoaMQTTQoS = .qos1) {
        mqtt?.publish(topic, withString: message, qos: qos)
    }
    
    func publish(topic: String, data: Data, qos: CocoaMQTTQoS = .qos1) {
        mqtt?.publish(CocoaMQTTMessage(topic: topic, payload: Array(data), qos: qos))
    }
    
    // MARK: - Private
    
    private func setupReachability() {
        reachability.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("🌐 网络已连接，检查 MQTT 状态...")
                self?.handleAutoReconnect()
            } else {
                print("⚠️ 网络断开")
            }
        }
        reachability.start(queue: .main)
    }
    
    private func handleAutoReconnect() {
        guard !isConnecting, let mqtt = mqtt, mqtt.connState == .disconnected else { return }
        print("🔄 尝试自动重连...")
        _ = mqtt.connect()
    }
}

// MARK: - CocoaMQTTDelegate
extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        
    }
    
   
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        isConnecting = false
        if ack == .accept {
            print("✅ MQTT 连接成功")
            retryCount = 0
            onConnectionStatusChange?(.connected)
            
            // 连接成功后自动订阅基础频道
            subscribe(topic: MQTTTopics.system)
        } else {
            print("❌ MQTT 连接拒绝: \(ack)")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        // 消息发送成功
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("📩 收到消息: [\(message.topic)]")
        // 交给分发器处理
        MQTTMessageDispatcher.shared.dispatch(message)
        onMessageReceived?(message)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: [String], failed: [String]) {
        print("🔔 订阅成功: \(success), 失败: \(failed)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        isConnecting = false
        print("🔌 MQTT 断开连接: \(err?.localizedDescription ?? "未知原因")")
        onConnectionStatusChange?(.disconnected)
        
        // 指数退避重连逻辑
        if retryCount < maxRetryCount {
            retryCount += 1
            let delay = Double(retryCount * 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.handleAutoReconnect()
            }
        }
    }
}
