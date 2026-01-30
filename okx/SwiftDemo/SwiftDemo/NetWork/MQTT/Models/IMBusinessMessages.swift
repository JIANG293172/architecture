import Foundation

/// 聊天消息模型
struct IMChatMessage: MQTTMessageProtocol, Codable {
    var msgId: String
    var type: MQTTMessageType = .chat
    var timestamp: Int64
    
    let senderId: String
    let content: String
    let chatId: String
    
    static func decode(from data: Data) -> IMChatMessage? {
        return try? JSONDecoder().decode(IMChatMessage.self, from: data)
    }
    
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

/// 系统通知模型
struct IMSystemNotice: MQTTMessageProtocol, Codable {
    var msgId: String
    var type: MQTTMessageType = .system
    var timestamp: Int64
    
    let title: String
    let body: String
    let actionUrl: String?
    
    static func decode(from data: Data) -> IMSystemNotice? {
        return try? JSONDecoder().decode(IMSystemNotice.self, from: data)
    }
    
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
