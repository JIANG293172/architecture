import Foundation
import CocoaMQTT

/// 基于 MQTT 的传输层实现 (Adapter Pattern)
/// 封装要点：IM 为什么选择 MQTT 而不是原生 WebSocket？
/// 答：1. MQTT 拥有原生 QoS 机制 (0, 1, 2) 保证消息可靠性；
///    2. 协议开销小，心跳包极小，省电省流量；
///    3. 天然支持发布/订阅模式，适合群聊场景。
public class MQTTTransport: NSObject, IMTransportProtocol {
    private var mqtt: CocoaMQTT?
    private let host: String
    private let port: UInt16
    private let clientID: String
    
    public weak var delegate: IMTransportDelegate?
    
    public var isConnected: Bool {
        return mqtt?.connState == .connected
    }
    
    public init(host: String, port: UInt16, clientID: String) {
        self.host = host
        self.port = port
        self.clientID = clientID
        super.init()
    }
    
    public func connect() {
        mqtt = CocoaMQTT(clientID: clientID, host: host, port: port)
        mqtt?.keepAlive = 60
        mqtt?.delegate = self
        _ = mqtt?.connect()
    }
    
    public func disconnect() {
        mqtt?.disconnect()
    }
    
    public func send(data: Data, topic: String, qos: Int) {
        let mqttQos = CocoaMQTTQoS(rawValue: UInt8(qos)) ?? .qos1
        mqtt?.publish(CocoaMQTTMessage(topic: topic, payload: Array(data), qos: mqttQos))
    }
    
    public func subscribe(topic: String) {
        mqtt?.subscribe(topic, qos: .qos1)
    }
}

extension MQTTTransport: CocoaMQTTDelegate {
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        delegate?.transport(self, didConnect: ack == .accept)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        delegate?.transport(self, didReceiveData: Data(message.payload), topic: message.topic)
    }
    
    // Unused CocoaMQTTDelegate methods
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {}
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {}
    public func mqttDidPing(_ mqtt: CocoaMQTT) {}
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        delegate?.transport(self, didDisconnect: err)
    }
}
