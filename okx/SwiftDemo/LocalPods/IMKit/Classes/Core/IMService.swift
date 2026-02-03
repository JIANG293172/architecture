import Foundation

/// IM 核心服务类 (Facade Pattern)
/// 封装要点：IM 系统如何保证消息不丢失？
/// 答：1. 应用层 ACK：客户端收到消息后，向服务端回复 ACK 消息；
///    2. 重试机制：发送端在一定时间内未收到 ACK 则触发重试；
///    3. 离线拉取：客户端上线后主动拉取离线期间的 seqId 缺口。
public class IMService: IMTransportDelegate {
    public static let shared = IMService()
    
    private var transport: IMTransportProtocol?
    private let dispatcher = IMMessageDispatcher()
    
    // 待处理的消息缓存（用于重试逻辑）
    private var pendingMessages: [String: (Data, String)] = [:]
    
    private init() {}
    
    public func setup(with transport: IMTransportProtocol) {
        self.transport = transport
        self.transport?.delegate = self
    }
    
    public func connect() {
        transport?.connect()
    }
    
    /// 发送聊天消息
    /// 封装要点：发送消息的流程？
    /// 答：1. 本地入库（状态：发送中）；2. 传输层发送；3. 开启超时定时器；4. 收到 ACK 后更新数据库状态。
    public func sendMessage(_ message: IMMessageProtocol, topic: String) {
        guard let data = message.encode() else { return }
        
        // 1. 本地持久化 (Mock)
        print("💾 [IMService] 消息入库: \(message.msgId)")
        
        // 2. 传输层发送
        transport?.send(data: data, topic: topic, qos: 1)
        
        // 3. 记录到待确认列表
        pendingMessages[message.msgId] = (data, topic)
    }
    
    // MARK: - IMTransportDelegate
    
    public func transport(_ transport: IMTransportProtocol, didConnect isConnected: Bool) {
        print("🌐 [IMService] 连接状态: \(isConnected)")
        if isConnected {
            // 自动订阅基础 Topic
            transport.subscribe(topic: "im/chat/#")
            transport.subscribe(topic: "im/system/#")
        }
    }
    
    public func transport(_ transport: IMTransportProtocol, didReceiveData data: Data, topic: String) {
        // 交给分发器处理
        dispatcher.dispatch(data: data, topic: topic)
    }
    
    public func transport(_ transport: IMTransportProtocol, didDisconnect error: Error?) {
        print("🔌 [IMService] 连接断开: \(error?.localizedDescription ?? "未知")")
        // 封装要点：指数退避算法进行重连
        // retryCount++ -> delay = 2^retryCount
    }
}

/// 消息分发器
internal class IMMessageDispatcher {
    func dispatch(data: Data, topic: String) {
        // 1. 尝试解析基础消息体 (JSON/PB)
        // 2. 根据 topic 或 type 路由到对应的处理单元
        print("📩 [IMDispatcher] 收到 Topic: \(topic) 的原始数据")
        
        // 这里可以实现类似之前 MQTTMessageDispatcher 的策略模式
    }
}
