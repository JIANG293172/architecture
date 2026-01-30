import Foundation
import CocoaMQTT

/// MQTT 消息协议，所有业务消息模型需遵循此协议
protocol MQTTMessageProtocol {
    /// 消息唯一标识
    var msgId: String { get }
    /// 业务类型
    var type: MQTTMessageType { get }
    /// 消息发送时间戳
    var timestamp: Int64 { get }
    
    /// 从原始数据解析
    static func decode(from data: Data) -> Self?
    /// 编码为二进制数据
    func encode() -> Data?
}

/// 业务消息类型枚举
enum MQTTMessageType: String, Codable {
    case chat = "chat"           // 单聊/群聊消息
    case system = "system"       // 系统通知
    case heartbeat = "heartbeat" // 心跳
    case unknown = "unknown"
}
