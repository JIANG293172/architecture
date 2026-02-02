import Foundation

/// 基础聊天消息模型
public struct IMChatMessage: IMMessageProtocol, Codable {
    public let msgId: String
    public let seqId: Int64
    public let type: IMMessageType = .chat
    public let senderId: String
    public let timestamp: Int64
    
    public let content: String
    public let chatId: String
    
    public init(msgId: String = UUID().uuidString, 
                seqId: Int64, 
                senderId: String, 
                content: String, 
                chatId: String) {
        self.msgId = msgId
        self.seqId = seqId
        self.senderId = senderId
        self.content = content
        self.chatId = chatId
        self.timestamp = Int64(Date().timeIntervalSince1970)
    }
    
    public func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    public static func decode(from data: Data) -> IMChatMessage? {
        return try? JSONDecoder().decode(IMChatMessage.self, from: data)
    }
}
