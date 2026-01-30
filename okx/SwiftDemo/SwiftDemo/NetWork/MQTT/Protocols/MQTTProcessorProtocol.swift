import Foundation

/// MQTT 消息处理器协议（策略模式接口）
protocol MQTTProcessorProtocol {
    /// 能够处理的消息类型
    var supportedTypes: [MQTTMessageType] { get }
    
    /// 处理接收到的消息
    /// - Parameters:
    ///   - message: 遵循协议的消息体
    ///   - topic: 来源主题
    func process(message: MQTTMessageProtocol, topic: String)
}
