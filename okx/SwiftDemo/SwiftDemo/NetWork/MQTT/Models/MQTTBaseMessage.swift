import Foundation

/// 基础消息结构 - 演示如何封装统一的协议头
struct MQTTBaseMessage: Codable {
    let msgId: String
    let type: String
    let timestamp: Int64
    
    enum CodingKeys: String, CodingKey {
        case msgId = "msg_id"
        case type
        case timestamp
    }
    
    init(msgId: String = UUID().uuidString, type: MQTTMessageType, timestamp: Int64 = Int64(Date().timeIntervalSince1970)) {
        self.msgId = msgId
        self.type = type.rawValue
        self.timestamp = timestamp
    }
}
