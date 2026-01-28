import Foundation
import CocoaMQTT

/// MQTT 消息分发器 - 核心分发逻辑，根据 Topic 或 Payload 类型路由到不同的处理器 (Strategy Pattern)
class MQTTMessageDispatcher {
    static let shared = MQTTMessageDispatcher()
    
    /// 注册的处理器列表
    private var processors: [MQTTProcessorProtocol] = []
    
    private init() {
        // 默认注册一些基础处理器
        register(processor: ChatMessageProcessor())
        register(processor: SystemNoticeProcessor())
    }
    
    /// 注册新的处理器
    func register(processor: MQTTProcessorProtocol) {
        processors.append(processor)
    }
    
    /// 核心分发逻辑
    func dispatch(_ rawMessage: CocoaMQTTMessage) {
        let payload = Data(rawMessage.payload)
        let topic = rawMessage.topic
        
        // 1. 先尝试解析出基础消息头，获取业务类型
        // 实际开发中通常会在 Payload 里的某个字段定义 type，或者通过 Topic 区分
        
        if topic.contains("chat") {
            if let chatMsg = IMChatMessage.decode(from: payload) {
                findProcessorAndExecute(message: chatMsg, topic: topic)
            }
        } else if topic.contains("system") {
            if let systemMsg = IMSystemNotice.decode(from: payload) {
                findProcessorAndExecute(message: systemMsg, topic: topic)
            }
        } else {
            print("⚠️ 未知主题或格式的消息: \(topic)")
        }
    }
    
    private func findProcessorAndExecute(message: MQTTMessageProtocol, topic: String) {
        // 策略模式应用：查找支持该消息类型的处理器
        let matchedProcessors = processors.filter { $0.supportedTypes.contains(message.type) }
        
        if matchedProcessors.isEmpty {
            print("❌ 未找到能处理 \(message.type) 类型消息的处理器")
            return
        }
        
        for processor in matchedProcessors {
            processor.process(message: message, topic: topic)
        }
    }
}

// MARK: - 具体处理器实现 (Strategy Implementation)

/// 聊天消息处理器
class ChatMessageProcessor: MQTTProcessorProtocol {
    var supportedTypes: [MQTTMessageType] { return [.chat] }
    
    func process(message: MQTTMessageProtocol, topic: String) {
        guard let chatMsg = message as? IMChatMessage else { return }
        print("💬 [聊天处理器] 收到来自 \(chatMsg.senderId) 的消息: \(chatMsg.content)")
        
        // 发送本地通知或更新 UI
        Foundation.NotificationCenter.default.post(name: .didReceiveIMChatMessage, object: chatMsg)
    }
}

/// 系统通知处理器
class SystemNoticeProcessor: MQTTProcessorProtocol {
    var supportedTypes: [MQTTMessageType] { return [.system] }
    
    func process(message: MQTTMessageProtocol, topic: String) {
        guard let notice = message as? IMSystemNotice else { return }
        print("📢 [系统处理器] 收到系统通知: \(notice.title) - \(notice.body)")
        
        Foundation.NotificationCenter.default.post(name: .didReceiveIMSystemNotice, object: notice)
    }
}

// MARK: - Notification Extension
extension NSNotification.Name {
     static let didReceiveIMChatMessage = NSNotification.Name("didReceiveIMChatMessage")
    static let didReceiveIMSystemNotice = NSNotification.Name("didReceiveIMSystemNotice")
}
