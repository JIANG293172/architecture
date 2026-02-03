import Foundation

/// IM 消息基础协议 - 所有业务消息需遵循此协议
/// 封装要点：IM 系统消息协议设计（Protocols Buffer vs JSON）
/// 在高性能 IM 中，通常推荐使用 PB (Protocols Buffer) 来减少数据包大小和序列化开销
public protocol IMMessageProtocol {
    /// 消息唯一标识 (msgId)
    var msgId: String { get }
    
    /// 序列号 (seqId) - 用于保证消息时序性
    /// 封装要点：如何解决消息乱序问题？
    /// 答：服务端生成全局单调递增的 seqId，客户端根据 seqId 进行排序和去重
    var seqId: Int64 { get }
    
    /// 业务类型
    var type: IMMessageType { get }
    
    /// 发送者 ID
    var senderId: String { get }
    
    /// 消息发送时间戳
    var timestamp: Int64 { get }
    
    /// 编码为二进制数据
    func encode() -> Data?
}

/// 业务消息类型枚举
public enum IMMessageType: String, Codable {
    case chat = "chat"           // 单聊消息
    case group = "group"         // 群聊消息
    case system = "system"       // 系统通知
    case ack = "ack"             // 确认消息
    case heartbeat = "heartbeat" // 心跳
    case unknown = "unknown"
}

/// 传输层协议抽象
/// 封装要点：为什么要做传输层抽象？
/// 答：为了支持多种长连接协议（MQTT/WebSocket/gRPC），解耦业务逻辑与底层通信实现
public protocol IMTransportProtocol: AnyObject {
    var isConnected: Bool { get }
    func connect()
    func disconnect()
    func send(data: Data, topic: String, qos: Int)
    func subscribe(topic: String)
    
    var delegate: IMTransportDelegate? { get set }
}

public protocol IMTransportDelegate: AnyObject {
    func transport(_ transport: IMTransportProtocol, didConnect isConnected: Bool)
    func transport(_ transport: IMTransportProtocol, didReceiveData data: Data, topic: String)
    func transport(_ transport: IMTransportProtocol, didDisconnect error: Error?)
}
