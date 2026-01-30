import Foundation

/// MQTT 配置信息
struct MQTTConfig {
    let host: String
    let port: UInt16
    let clientID: String
    var keepAlive: UInt16 = 60
    var cleanSession: Bool = true
    var username: String? = nil
    var password: String? = nil
    
    static var `default`: MQTTConfig {
        return MQTTConfig(
            host: "broker.emqx.io", // 公共测试 Broker
            port: 1883,
            clientID: "iOS_Demo_\(UUID().uuidString.prefix(8))"
        )
    }
}

/// 主题定义
struct MQTTTopics {
    static let chat = "im/chat/#"
    static let system = "im/system/notice"
    
    static func userChat(userId: String) -> String {
        return "im/chat/\(userId)"
    }
}
