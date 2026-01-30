import UIKit
import Foundation
import SwiftProtobuf // 引入 SwiftProtobuf 库

/// Protocol Buffer 演示视图控制器
/// 本示例展示了 Protocol Buffer 在 iOS 中的完整落地实现
/// 使用 SwiftProtobuf 库进行高性能的序列化和反序列化
class ProtocolBufferViewController: UIViewController {
    
    /// 显示演示结果的文本视图
    private let resultTextView = UITextView()
    /// 演示类型选择分段控件
    private let demoTypeSegmentedControl = UISegmentedControl()
    /// 执行演示按钮
    private let executeButton = UIButton(type: .system)
    /// 保存演示结果
    private var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Protobuf 最佳实践"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置分段控件
        demoTypeSegmentedControl.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
        demoTypeSegmentedControl.insertSegment(withTitle: "基础", at: 0, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "复杂业务", at: 1, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "网络模拟", at: 2, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "性能对比", at: 3, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "JSON互转", at: 4, animated: false)
        demoTypeSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(demoTypeSegmentedControl)
        
        // 设置执行按钮
        executeButton.frame = CGRect(x: 100, y: 160, width: view.frame.width - 200, height: 44)
        executeButton.setTitle("开始演示", for: .normal)
        executeButton.setTitleColor(.white, for: .normal)
        executeButton.backgroundColor = .systemBlue
        executeButton.layer.cornerRadius = 22
        view.addSubview(executeButton)
        
        // 设置结果文本视图
        resultTextView.frame = CGRect(x: 20, y: 220, width: view.frame.width - 40, height: view.frame.height - 300)
        resultTextView.backgroundColor = .secondarySystemBackground
        resultTextView.textColor = .label
        resultTextView.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        resultTextView.isEditable = false
        resultTextView.layer.cornerRadius = 8.0
        resultTextView.text = "请选择演示类型并点击执行..."
        view.addSubview(resultTextView)
    }
    
    /// 设置按钮动作
    private func setupActions() {
        executeButton.addTarget(self, action: #selector(executeButtonTapped), for: .touchUpInside)
    }
    
    /// 执行演示按钮点击事件
    @objc private func executeButtonTapped() {
        results.removeAll()
        
        switch demoTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            runBasicTypesDemo()
        case 1:
            runComplexOrderDemo()
        case 2:
            runNetworkSimulationDemo()
        case 3:
            runPerformanceComparisonDemo()
        case 4:
            runJSONInteropDemo()
        default:
            break
        }
        
        updateResultTextView()
    }
    
    /// 1. 基础类型示例
    private func runBasicTypesDemo() {
        appendResult("🚀 [基础类型示例]")
        
        // 使用 SwiftProtobuf 生成的消息类
        var user = PBUser()
        user.id = 1001
        user.name = "阿强"
        user.email = "qiang@okx.com"
        user.isActive = true
        user.score = 99.8
        user.tags = ["Swift", "Protobuf", "Crypto"]
        
        do {
            // 序列化为二进制 Data
            let binaryData = try user.serializedData()
            appendResult("✅ 序列化成功: \(binaryData.count) 字节")
            appendResult("📦 字节内容: \(binaryData.hexDescription)")
            
            // 反序列化
            let decodedUser = try PBUser(serializedData: binaryData)
            appendResult("🔍 反序列化成功:")
            appendResult("   - ID: \(decodedUser.id)")
            appendResult("   - Name: \(decodedUser.name)")
            appendResult("   - Tags: \(decodedUser.tags.joined(separator: ", "))")
        } catch {
            appendResult("❌ 错误: \(error)")
        }
    }
    
    /// 2. 复杂业务场景（订单/嵌套/枚举/重复字段）
    private func runComplexOrderDemo() {
        appendResult("🚀 [复杂业务场景: 订单系统]")
        
        var order = PBOrder()
        order.orderID = "ORD-2024-001"
        order.status = .paid
        order.timestamp = Int64(Date().timeIntervalSince1970)
        
        // 嵌套商品 1
        var p1 = PBProduct()
        p1.id = 501
        p1.name = "Bitcoin"
        p1.price = 65000.0
        
        // 嵌套商品 2
        var p2 = PBProduct()
        p2.id = 502
        p2.name = "Ethereum"
        p2.price = 3500.0
        
        order.items = [p1, p2]
        
        // 嵌套地址
        var addr = PBAddress()
        addr.city = "Singapore"
        addr.street = "Marina Bay"
        order.address = addr
        
        do {
            let data = try order.serializedData()
            appendResult("✅ 复杂订单序列化成功: \(data.count) 字节")
            
            let decodedOrder = try PBOrder(serializedData: data)
            appendResult("🔍 订单详情:")
            appendResult("   - ID: \(decodedOrder.orderID)")
            appendResult("   - 状态: \(decodedOrder.status)")
            appendResult("   - 商品数量: \(decodedOrder.items.count)")
            appendResult("   - 首个商品: \(decodedOrder.items.first?.name ?? "") ($\(decodedOrder.items.first?.price ?? 0))")
            appendResult("   - 配送城市: \(decodedOrder.address.city)")
        } catch {
            appendResult("❌ 错误: \(error)")
        }
    }
    
    /// 3. 网络模拟（从原始二进制流解析）
    private func runNetworkSimulationDemo() {
        appendResult("🚀 [网络模拟: 原始二进制解析]")
        
        // 模拟更复杂的网络场景：一个包含嵌套对象和枚举的订单数据
        // 对应 PBOrder: 
        // order_id: "NET-99" (1: 0a 06 4e 45 54 2d 39 39)
        // status: paid (2: 10 01)
        // timestamp: 1711234567 (5: 28 d7 b3 a3 b1 06)
        let mockOrderBytes: [UInt8] = [
            0x0a, 0x06, 0x4e, 0x45, 0x54, 0x2d, 0x39, 0x39, // tag 1 (string), len 6, "NET-99"
            0x10, 0x01,                                     // tag 2 (varint), value 1 (paid)
            0x28, 0xd7, 0xb3, 0xa3, 0xb1, 0x06              // tag 5 (varint), value 1711234567
        ]
        let networkData = Data(mockOrderBytes)
        
        appendResult("📡 模拟从网络 Socket 接收到字节流:")
        appendResult("📦 原始 Hex: \(networkData.hexDescription)")
        
        do {
            // 使用 SwiftProtobuf 库的核心解析能力
            let order = try PBOrder(serializedData: networkData)
            
            appendResult("✅ SwiftProtobuf 库解析成功:")
            appendResult("   - 订单编号: \(order.orderID)")
            appendResult("   - 订单状态: \(order.status == .paid ? "已支付 (1)" : "其他")")
            appendResult("   - 时间戳: \(order.timestamp)")
            
            // 演示动态性：如果增加未知字段，Protobuf 也能保持兼容
            appendResult("💡 提示: Protobuf 具有向前兼容性，即使收到定义外的字段也不会崩溃")
        } catch {
            appendResult("❌ 解析失败: \(error)")
        }
    }
    
    /// 4. 性能对比 (Protobuf vs JSON)
    private func runPerformanceComparisonDemo() {
        appendResult("🚀 [性能大比拼: PB vs JSON]")
        
        var user = PBUser()
        user.id = 999
        user.name = "PerformanceTester"
        user.tags = Array(repeating: "TestTag", count: 20)
        
        let count = 5000
        
        // PB 性能
        let startPB = CACurrentMediaTime()
        for _ in 0..<count {
            let data = try! user.serializedData()
            _ = try! PBUser(serializedData: data)
        }
        let endPB = CACurrentMediaTime()
        let pbTime = (endPB - startPB) * 1000
        
        // JSON 性能 (使用内置 JSONEncoder)
        struct UserJSON: Codable {
            let id: Int32
            let name: String
            let tags: [String]
        }
        let userJSON = UserJSON(id: user.id, name: user.name, tags: user.tags)
        let startJSON = CACurrentMediaTime()
        for _ in 0..<count {
            let data = try! JSONEncoder().encode(userJSON)
            _ = try! JSONDecoder().decode(UserJSON.self, from: data)
        }
        let endJSON = CACurrentMediaTime()
        let jsonTime = (endJSON - startJSON) * 1000
        
        appendResult("📊 结果 (运行 \(count) 次):")
        appendResult("   - Protobuf: \(String(format: "%.2f", pbTime))ms")
        appendResult("   - JSON: \(String(format: "%.2f", jsonTime))ms")
        appendResult("📈 提升: \(String(format: "%.1f", jsonTime / pbTime))x 速度")
        
        let pbSize = try! user.serializedData().count
        let jsonSize = try! JSONEncoder().encode(userJSON).count
        appendResult("📉 体积对比: PB(\(pbSize)B) vs JSON(\(jsonSize)B)")
        appendResult("   - 节省空间: \(String(format: "%.1f", Double(jsonSize-pbSize)/Double(jsonSize)*100))%")
    }
    
    /// 5. JSON 互转示例 (Protobuf 的强大特性)
    private func runJSONInteropDemo() {
        appendResult("🚀 [Protobuf <=> JSON 互转]")
        
        var user = PBUser()
        user.id = 888
        user.name = "李小龙"
        
        do {
            // PB -> JSON
            let jsonString = try user.jsonString()
            appendResult("✅ PB 转 JSON 字符串:")
            appendResult("   \(jsonString)")
            
            // JSON -> PB
            let newJSON = "{\"id\": 777, \"name\": \"叶问\"}"
            let decodedFromJSON = try PBUser(jsonString: newJSON)
            appendResult("✅ JSON 转回 PB 成功:")
            appendResult("   - ID: \(decodedFromJSON.id)")
            appendResult("   - Name: \(decodedFromJSON.name)")
        } catch {
            appendResult("❌ 转换失败: \(error)")
        }
    }
    
    private func appendResult(_ text: String) {
        results.append(text)
        print(text)
    }
    
    private func updateResultTextView() {
        resultTextView.text = results.joined(separator: "\n")
        let bottom = NSMakeRange(resultTextView.text.count - 1, 1)
        resultTextView.scrollRangeToVisible(bottom)
    }
}

// MARK: - 数据转换扩展
extension Data {
    var hexDescription: String {
        return map { String(format: "%02x", $0) }.joined(separator: " ")
    }
}

// MARK: - Protobuf 消息类定义 (模拟 protoc 生成的代码)
// 注意：在实际项目中，这些代码是由 protoc --swift_out=. 生成的

struct PBUser: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "PBUser"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "id"),
        2: .same(proto: "name"),
        3: .same(proto: "email"),
        4: .standard(proto: "is_active"),
        5: .same(proto: "score"),
        6: .same(proto: "tags"),
    ]

    var id: Int32 = 0
    var name: String = String()
    var email: String = String()
    var isActive: Bool = false
    var score: Double = 0
    var tags: [String] = []

    var unknownFields = SwiftProtobuf.UnknownStorage()

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            switch fieldNumber {
            case 1: try decoder.decodeSingularInt32Field(value: &self.id)
            case 2: try decoder.decodeSingularStringField(value: &self.name)
            case 3: try decoder.decodeSingularStringField(value: &self.email)
            case 4: try decoder.decodeSingularBoolField(value: &self.isActive)
            case 5: try decoder.decodeSingularDoubleField(value: &self.score)
            case 6: try decoder.decodeRepeatedStringField(value: &self.tags)
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if self.id != 0 { try visitor.visitSingularInt32Field(value: self.id, fieldNumber: 1) }
        if !self.name.isEmpty { try visitor.visitSingularStringField(value: self.name, fieldNumber: 2) }
        if !self.email.isEmpty { try visitor.visitSingularStringField(value: self.email, fieldNumber: 3) }
        if self.isActive != false { try visitor.visitSingularBoolField(value: self.isActive, fieldNumber: 4) }
        if self.score != 0 { try visitor.visitSingularDoubleField(value: self.score, fieldNumber: 5) }
        if !self.tags.isEmpty { try visitor.visitRepeatedStringField(value: self.tags, fieldNumber: 6) }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func ==(lhs: PBUser, rhs: PBUser) -> Bool {
        if lhs.id != rhs.id {return false}
        if lhs.name != rhs.name {return false}
        if lhs.email != rhs.email {return false}
        if lhs.isActive != rhs.isActive {return false}
        if lhs.score != rhs.score {return false}
        if lhs.tags != rhs.tags {return false}
        if lhs.unknownFields != rhs.unknownFields {return false}
        return true
    }
}

// 订单枚举
enum PBOrderStatus: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case pending // 0
    case paid    // 1
    case shipped // 2
    case UNRECOGNIZED(Int)

    init() { self = .pending }

    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .pending
        case 1: self = .paid
        case 2: self = .shipped
        default: self = .UNRECOGNIZED(rawValue)
        }
    }

    var rawValue: Int {
        switch self {
        case .pending: return 0
        case .paid: return 1
        case .shipped: return 2
        case .UNRECOGNIZED(let i): return i
        }
    }
}

// 商品消息
struct PBProduct: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "PBProduct"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "id"),
        2: .same(proto: "name"),
        3: .same(proto: "price"),
    ]
    var id: Int64 = 0
    var name: String = String()
    var price: Double = 0
    var unknownFields = SwiftProtobuf.UnknownStorage()
    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            switch fieldNumber {
            case 1: try decoder.decodeSingularInt64Field(value: &self.id)
            case 2: try decoder.decodeSingularStringField(value: &self.name)
            case 3: try decoder.decodeSingularDoubleField(value: &self.price)
            default: break
            }
        }
    }
    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if self.id != 0 { try visitor.visitSingularInt64Field(value: self.id, fieldNumber: 1) }
        if !self.name.isEmpty { try visitor.visitSingularStringField(value: self.name, fieldNumber: 2) }
        if self.price != 0 { try visitor.visitSingularDoubleField(value: self.price, fieldNumber: 3) }
        try unknownFields.traverse(visitor: &visitor)
    }
}

// 地址消息
struct PBAddress: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "PBAddress"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [1: .same(proto: "city"), 2: .same(proto: "street")]
    var city: String = String()
    var street: String = String()
    var unknownFields = SwiftProtobuf.UnknownStorage()
    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            switch fieldNumber {
            case 1: try decoder.decodeSingularStringField(value: &self.city)
            case 2: try decoder.decodeSingularStringField(value: &self.street)
            default: break
            }
        }
    }
    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if !self.city.isEmpty { try visitor.visitSingularStringField(value: self.city, fieldNumber: 1) }
        if !self.street.isEmpty { try visitor.visitSingularStringField(value: self.street, fieldNumber: 2) }
        try unknownFields.traverse(visitor: &visitor)
    }
}

// 订单消息
struct PBOrder: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = "PBOrder"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .standard(proto: "order_id"),
        2: .same(proto: "status"),
        3: .same(proto: "items"),
        4: .same(proto: "address"),
        5: .same(proto: "timestamp"),
    ]
    var orderID: String = String()
    var status: PBOrderStatus = .pending
    var items: [PBProduct] = []
    var address: PBAddress {
        get {return _address ?? PBAddress()}
        set {_address = newValue}
    }
    private var _address: PBAddress? = nil
    var hasAddress: Bool {return self._address != nil}
    var timestamp: Int64 = 0
    var unknownFields = SwiftProtobuf.UnknownStorage()

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            switch fieldNumber {
            case 1: try decoder.decodeSingularStringField(value: &self.orderID)
            case 2: try decoder.decodeSingularEnumField(value: &self.status)
            case 3: try decoder.decodeRepeatedMessageField(value: &self.items)
            case 4: try decoder.decodeSingularMessageField(value: &self._address)
            case 5: try decoder.decodeSingularInt64Field(value: &self.timestamp)
            default: break
            }
        }
    }
    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if !self.orderID.isEmpty { try visitor.visitSingularStringField(value: self.orderID, fieldNumber: 1) }
        if self.status != .pending { try visitor.visitSingularEnumField(value: self.status, fieldNumber: 2) }
        if !self.items.isEmpty { try visitor.visitRepeatedMessageField(value: self.items, fieldNumber: 3) }
        if let v = self._address { try visitor.visitSingularMessageField(value: v, fieldNumber: 4) }
        if self.timestamp != 0 { try visitor.visitSingularInt64Field(value: self.timestamp, fieldNumber: 5) }
        try unknownFields.traverse(visitor: &visitor)
    }
}
