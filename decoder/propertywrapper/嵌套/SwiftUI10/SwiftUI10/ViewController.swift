import UIKit
import RxSwift
import Foundation

/// 跟 CodableWrappers 的实现思路相类似
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 运行测试
        print("🔧 SafeValue Property Wrapper 最终无报错版本测试")
        print(String(repeating: "=", count: 50))

        // 新增：嵌套 Model 测试
//        testNestedModelParsing()
        
//        CompleteTests.run()
//        PracticalExample.simulateAPIResponses()

        // 单个测试示例（保留原有）
        print("\n📝 单个测试示例:")
        let singleJSON = """
        {
            "id": "999",
            "age": "30",
            "phone": 13800138000,
            "score": 99.5,
            "is_active": "true",
            "is_premium": 1,
            "price": "299.99",
            "rating": 5,
            "name": "Test User",
            "email": "test@example.com",
            "address": {
                "province": "广东省",
                "city": "深圳市",
                "zip_code": "518000" // String 转 Int 测试
            }
        }
        """

        if let data = singleJSON.data(using: .utf8) {
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                print("✅ 测试通过!")
                print("   ID (String→Int): \(model.id)")
                print("   Phone (Int→String): \(model.phone)")
                print("   Is Active (String→Bool): \(model.isActive)")
                print("   Price (String→Double): \(model.price)")
                // 新增：打印嵌套 Model 数据
                if let address = model.address {
                    print("   省份: \(address.province)")
                    print("   城市: \(address.city)")
                    print("   邮编 (String→Int): \(address.zipCode)")
                }
            } catch {
                print("❌ 测试失败: \(error)")
            }
        }
    }
    
    // MARK: - 新增：嵌套 Model 专项测试方法
    private func testNestedModelParsing() {
        print("\n📝 嵌套 Model 专项测试:")
        // 测试场景1：嵌套 Model 完整且有类型转换
        let nestedJSON1 = """
        {
            "id": "1001",
            "name": "张三",
            "address": {
                "province": "江苏省",
                "city": "南京市",
                "zip_code": "210000"
            }
        }
        """
        
        // 测试场景2：嵌套 Model 缺失
        let nestedJSON2 = """
        {
            "id": "1002",
            "name": "李四"
        }
        """
        
        // 测试场景3：嵌套 Model 内部字段类型错误
        let nestedJSON3 = """
        {
            "id": "1003",
            "name": "王五",
            "address": {
                "province": 123, // Int 转 String 测试
                "city": true,    // Bool 转 String 测试
                "zip_code": "abc" // 无效字符串转 Int 测试
            }
        }
        """
        
        // 执行测试
        let testScenarios = [
            ("完整嵌套数据", nestedJSON1),
            ("缺失嵌套数据", nestedJSON2),
            ("嵌套数据类型错误", nestedJSON3)
        ]
        
        for (scenario, jsonString) in testScenarios {
            print("\n🔹 测试场景：\(scenario)")
            guard let data = jsonString.data(using: .utf8) else {
                print("   ❌ JSON 格式错误")
                continue
            }
            
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                print("   ✅ 解码成功")
                print("   主模型 ID: \(model.id)")
                if let address = model.address {
                    print("   嵌套地址 - 省份: \(address.province)")
                    print("   嵌套地址 - 城市: \(address.city)")
                    print("   嵌套地址 - 邮编: \(address.zipCode)")
                } else {
                    print("   嵌套地址: nil (字段缺失)")
                }
            } catch {
                print("   ❌ 解码失败: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 修复后的 SafeValue 属性包装器（彻底解决可选类型判断问题）
@propertyWrapper
struct SafeValue<T: Codable>: Codable, CustomStringConvertible {
    private var value: T
    private let defaultValue: T
    
    var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    var projectedValue: Self {
        self
    }
    
    var description: String {
        "SafeValue(\(value))"
    }
    
    // MARK: - 初始化器
    init(wrappedValue: T) {
        self.value = wrappedValue
        self.defaultValue = wrappedValue
    }
    
    init(defaultValue: T) {
        self.value = defaultValue
        self.defaultValue = defaultValue
    }
    
    // MARK: - Codable 实现
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 安全初始化 defaultValue
        self.defaultValue = Self.getAppropriateDefaultValue(for: T.self)
        
        // 1. 先尝试直接解码（自定义结构体走这个逻辑）
        do {
            self.value = try container.decode(T.self)
            return
        } catch {
            // 基础类型解码失败，尝试类型转换；自定义结构体直接用默认值
            if Self.isBasicType(type: T.self) {
                print("⚠️ 直接解码失败: 尝试类型转换 for type \(T.self)")
                do {
                    self.value = try Self.decodeWithFallback(from: container)
                } catch {
                    print("❌ 类型转换失败: \(error)")
                    self.value = self.defaultValue
                }
            } else {
                // 自定义结构体解码失败，直接用默认值
                print("⚠️ 自定义结构体 \(T.self) 解码失败，使用默认值")
                self.value = self.defaultValue
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    // MARK: - 核心：判断是否是基础类型（只对基础类型做转换）
    private static func isBasicType(type: T.Type) -> Bool {
        let typeName = String(describing: type)
        // 基础类型列表（包括可选基础类型）
        let basicTypeNames = [
            "String", "Int", "Double", "Float", "Bool",
            "Optional<String>", "Optional<Int>", "Optional<Double>",
            "Optional<Float>", "Optional<Bool>"
        ]
        return basicTypeNames.contains(typeName)
    }
    
    // MARK: - 工具方法：判断是否是可选类型（解决泛型推断问题）
    private static func isOptionalType(type: Any.Type) -> Bool {
        // 方式1：通过Mirror判断（更安全）
        let mirror = Mirror(reflecting: type)
        return mirror.displayStyle == .optional ||
               String(describing: type).hasPrefix("Optional<")
    }
    
    // MARK: - 安全获取默认值（修复可选类型判断逻辑）
    private static func getAppropriateDefaultValue(for type: T.Type) -> T {
        // 先判断是否是基础类型
        switch type {
        // 基础类型
        case is String.Type:
            return "" as! T
        case is Int.Type:
            return 0 as! T
        case is Double.Type:
            return 0.0 as! T
        case is Float.Type:
            return 0.0 as! T
        case is Bool.Type:
            return false as! T
        // 基础类型的可选值
        case is Optional<String>.Type:
            let nilValue: String? = nil
            return nilValue as! T
        case is Optional<Int>.Type:
            let nilValue: Int? = nil
            return nilValue as! T
        case is Optional<Double>.Type:
            let nilValue: Double? = nil
            return nilValue as! T
        case is Optional<Float>.Type:
            let nilValue: Float? = nil
            return nilValue as! T
        case is Optional<Bool>.Type:
            let nilValue: Bool? = nil
            return nilValue as! T
        // 所有其他可选类型（包括自定义结构体的可选类型）
        default:
            if isOptionalType(type: type) {
                // 可选类型返回nil（强制转换，因为T是可选类型）
                let nilValue: Any? = nil
                return nilValue as! T
            } else {
                // 非可选自定义结构体：要求遵守DefaultInitializable
                if let defaultInstance = type as? DefaultInitializable.Type {
                    return defaultInstance.createDefault() as! T
                } else {
                    fatalError("⚠️ SafeValue 暂不支持无默认初始化器的类型 \(type)，请让该类型遵守 DefaultInitializable 协议")
                }
            }
        }
    }
    
    // MARK: - 基础类型转换逻辑
    private static func decodeWithFallback(from container: SingleValueDecodingContainer) throws -> T {
        switch T.self {
        case is String.Type:
            return try decodeToString(from: container) as! T
        case is Int.Type:
            return try decodeToInt(from: container) as! T
        case is Double.Type:
            return try decodeToDouble(from: container) as! T
        case is Float.Type:
            return try decodeToFloat(from: container) as! T
        case is Bool.Type:
            return try decodeToBool(from: container) as! T
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "SafeValue 暂不支持类型 \(T.self) 的转换")
        }
    }
    
    // MARK: - 各基础类型转换实现
    private static func decodeToString(from container: SingleValueDecodingContainer) throws -> String {
        if let string = try? container.decode(String.self) {
            return string
        } else if let int = try? container.decode(Int.self) {
            return String(int)
        } else if let double = try? container.decode(Double.self) {
            return double.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(double)) : String(double)
        } else if let bool = try? container.decode(Bool.self) {
            return bool ? "true" : "false"
        } else if container.decodeNil() {
            return ""
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "无法转换为 String")
    }
    
    private static func decodeToInt(from container: SingleValueDecodingContainer) throws -> Int {
        if let int = try? container.decode(Int.self) {
            return int
        } else if let string = try? container.decode(String.self) {
            if let int = Int(string) {
                return int
            }
            // 提取字符串中的数字（比如"25.7"→257，"一百二十三"→0）
            let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            return Int(numbers) ?? 0
        } else if let double = try? container.decode(Double.self) {
            return Int(double)
        } else if let bool = try? container.decode(Bool.self) {
            return bool ? 1 : 0
        } else if container.decodeNil() {
            return 0
        }
        return 0
    }
    
    private static func decodeToDouble(from container: SingleValueDecodingContainer) throws -> Double {
        if let double = try? container.decode(Double.self) {
            return double
        } else if let int = try? container.decode(Int.self) {
            return Double(int)
        } else if let string = try? container.decode(String.self) {
            if let double = Double(string) {
                return double
            }
            let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            return Double(numbers) ?? 0.0
        } else if let bool = try? container.decode(Bool.self) {
            return bool ? 1.0 : 0.0
        } else if container.decodeNil() {
            return 0.0
        }
        return 0.0
    }
    
    private static func decodeToFloat(from container: SingleValueDecodingContainer) throws -> Float {
        if let float = try? container.decode(Float.self) {
            return float
        } else if let double = try? container.decode(Double.self) {
            return Float(double)
        } else if let int = try? container.decode(Int.self) {
            return Float(int)
        } else if let string = try? container.decode(String.self), let float = Float(string) {
            return float
        } else if container.decodeNil() {
            return 0.0
        }
        return 0.0
    }
    
    private static func decodeToBool(from container: SingleValueDecodingContainer) throws -> Bool {
        if let bool = try? container.decode(Bool.self) {
            return bool
        } else if let int = try? container.decode(Int.self) {
            return int != 0
        } else if let string = try? container.decode(String.self) {
            let lowercased = string.lowercased()
            return ["true", "yes", "1", "on", "enabled"].contains(lowercased)
        } else if let double = try? container.decode(Double.self) {
            return double != 0
        } else if container.decodeNil() {
            return false
        }
        return false
    }
}

// MARK: - 协议：支持默认初始化的类型
protocol DefaultInitializable {
    static func createDefault() -> Self
}

// 基础类型遵守 DefaultInitializable（实际用不到，仅占位）
extension String: DefaultInitializable {
    static func createDefault() -> String { "" }
}
extension Int: DefaultInitializable {
    static func createDefault() -> Int { 0 }
}
extension Double: DefaultInitializable {
    static func createDefault() -> Double { 0.0 }
}
extension Float: DefaultInitializable {
    static func createDefault() -> Float { 0.0 }
}
extension Bool: DefaultInitializable {
    static func createDefault() -> Bool { false }
}

// MARK: - 新增：嵌套 Model（地址信息）
struct Address: Codable, DefaultInitializable {
    @SafeValue var province: String = ""
    @SafeValue var city: String = ""
    @SafeValue var zipCode: Int = 0 // 对应 JSON 的 zip_code
    
    // 自定义解码：缺失字段时用默认值
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 复用 SafeValue + decodeIfPresent 容错逻辑
        self.province = try container.decodeIfPresent(SafeValue<String>.self, forKey: .province)?.wrappedValue ?? ""
        self.city = try container.decodeIfPresent(SafeValue<String>.self, forKey: .city)?.wrappedValue ?? ""
        self.zipCode = try container.decodeIfPresent(SafeValue<Int>.self, forKey: .zipCode)?.wrappedValue ?? 0
    }
    
    // JSON 字段映射
    enum CodingKeys: String, CodingKey {
        case province, city
        case zipCode = "zip_code" // 映射下划线字段
    }
    
    // 遵守 DefaultInitializable 协议（自定义结构体必须实现）
    static func createDefault() -> Address {
        Address()
    }
    
    // 空初始化器（可选，方便手动创建）
    init() {}
}

// MARK: - 测试模型（支持缺失字段用默认值 + 嵌套 Model）
struct TestModel: Codable {
    @SafeValue var id: Int = 0
    @SafeValue var age: Int = 0
    @SafeValue var phone: String = ""
    @SafeValue var score: String = ""
    @SafeValue var isActive: Bool = false
    @SafeValue var isPremium: Bool = false
    @SafeValue var price: Double = 0.0
    @SafeValue var rating: Double = 0.0
    @SafeValue var optionalName: String? = nil
    @SafeValue var optionalValue: Int? = nil
    @SafeValue var name: String = ""
    @SafeValue var email: String = ""
    // 新增：嵌套 Model 字段（可选类型）
    @SafeValue var address: Address? = nil
    
    // 自定义解码：缺失字段时用默认值 + 解析嵌套 Model
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 原有字段解码逻辑（不变）
        self.id = try container.decodeIfPresent(SafeValue<Int>.self, forKey: .id)?.wrappedValue ?? 0
        self.age = try container.decodeIfPresent(SafeValue<Int>.self, forKey: .age)?.wrappedValue ?? 0
        self.phone = try container.decodeIfPresent(SafeValue<String>.self, forKey: .phone)?.wrappedValue ?? ""
        self.score = try container.decodeIfPresent(SafeValue<String>.self, forKey: .score)?.wrappedValue ?? ""
        self.isActive = try container.decodeIfPresent(SafeValue<Bool>.self, forKey: .isActive)?.wrappedValue ?? false
        self.isPremium = try container.decodeIfPresent(SafeValue<Bool>.self, forKey: .isPremium)?.wrappedValue ?? false
        self.price = try container.decodeIfPresent(SafeValue<Double>.self, forKey: .price)?.wrappedValue ?? 0.0
        self.rating = try container.decodeIfPresent(SafeValue<Double>.self, forKey: .rating)?.wrappedValue ?? 0.0
        self.optionalName = try container.decodeIfPresent(SafeValue<String?>.self, forKey: .optionalName)?.wrappedValue
        self.optionalValue = try container.decodeIfPresent(SafeValue<Int?>.self, forKey: .optionalValue)?.wrappedValue
        self.name = try container.decodeIfPresent(SafeValue<String>.self, forKey: .name)?.wrappedValue ?? ""
        self.email = try container.decodeIfPresent(SafeValue<String>.self, forKey: .email)?.wrappedValue ?? ""
        
        // 新增：解析嵌套 Model（容错逻辑）
        // decodeIfPresent 处理字段缺失 → SafeValue 处理类型错误 → wrappedValue 取出实际值
        self.address = try container.decodeIfPresent(SafeValue<Address?>.self, forKey: .address)?.wrappedValue
    }
    
    enum CodingKeys: String, CodingKey {
        case id, age, phone, score
        case isActive = "is_active"
        case isPremium = "is_premium"
        case price, rating, optionalName
        case optionalValue = "optional_value"
        case name, email
        // 新增：嵌套 Model 的 key
        case address
    }
}

// MARK: - 完整测试（补全JSON，避免字段缺失）
struct CompleteTests {
    static func run() {
        print("🧪 SafeValue 完整测试")
        print(String(repeating: "=", count: 50))
        
        testAllCases()
        testEdgeCases()
        testPerformance()
        
        print(String(repeating: "=", count: 50))
        print("✅ 测试完成")
    }
    
    static func testAllCases() {
        print("\n📊 测试各种数据类型转换:")
        
        // 补全所有字段，避免keyNotFound
        let testCases = [
            ("""
            {
                "id": "123",
                "age": "25",
                "phone": "",
                "score": "",
                "is_active": false,
                "is_premium": false,
                "price": 0,
                "rating": 0,
                "optionalName": nil,
                "optional_value": nil,
                "name": "",
                "email": "",
                "address": {
                    "province": "浙江省",
                    "city": "杭州市",
                    "zip_code": "310000"
                }
            }
            """, "String → Int", "id=123, age=25"),
            
            ("""
            {
                "id": 0,
                "age": 0,
                "phone": 13800138000,
                "score": 95.5,
                "is_active": false,
                "is_premium": false,
                "price": 0,
                "rating": 0,
                "optionalName": nil,
                "optional_value": nil,
                "name": "",
                "email": "",
                "address": {
                    "province": 456,
                    "city": true,
                    "zip_code": 310000
                }
            }
            """, "Number → String", "phone='13800138000', score='95.5'"),
            
            ("""
            {
                "id": 0,
                "age": 0,
                "phone": "",
                "score": "",
                "is_active": "true",
                "is_premium": 1,
                "price": 0,
                "rating": 0,
                "optionalName": nil,
                "optional_value": nil,
                "name": "",
                "email": "",
                "address": nil
            }
            """, "String/Int → Bool", "isActive=true, isPremium=true"),
            
            ("""
            {
                "id": 0,
                "age": 0,
                "phone": "",
                "score": "",
                "is_active": false,
                "is_premium": false,
                "price": "99.99",
                "rating": 4.5,
                "optionalName": nil,
                "optional_value": nil,
                "name": "",
                "email": ""
            }
            """, "String/Double → Double", "price=99.99, rating=4.5")
        ]
        
        for (jsonString, description, expected) in testCases {
            print("\n🔹 \(description)")
            guard let data = jsonString.data(using: .utf8) else { continue }
            
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                print("   ✅ 成功: \(expected)")
                print("     实际: id=\(model.id), age=\(model.age), phone='\(model.phone)'")
                if let address = model.address {
                    print("     嵌套地址: \(address.province)-\(address.city)-\(address.zipCode)")
                }
            } catch {
                print("   ❌ 失败: \(error)")
            }
        }
    }
    
    static func testEdgeCases() {
        print("\n📊 测试边界情况:")
        
        let edgeCases = [
            ("""
            {
                "id": "",
                "age": null,
                "phone": "",
                "score": "",
                "is_active": "invalid",
                "is_premium": -1,
                "price": "not_a_number",
                "rating": "4.5 stars",
                "optionalName": null,
                "optional_value": "999",
                "name": "John",
                "email": "john@example.com",
                "address": {
                    "province": "",
                    "city": null,
                    "zip_code": "非数字"
                }
            }
            """, "空值和无效数据 + 嵌套错误"),
            
            ("""
            {
                "id": "一百二十三",
                "age": "25.7",
                "phone": true,
                "score": 100,
                "is_active": "yes",
                "is_premium": "on",
                "price": 99,
                "rating": "4.5 stars",
                "optionalName": null,
                "optional_value": "999",
                "name": "John",
                "email": "john@example.com"
            }
            """, "混合问题数据 + 嵌套缺失"),
            
            ("""
            {
                "id": 1001,
                "age": 30,
                "phone": "13800138000",
                "score": "95.5",
                "is_active": true,
                "is_premium": false,
                "price": 199.99,
                "rating": 4.7,
                "optionalName": "Nickname",
                "optional_value": 42,
                "name": "Alice",
                "email": "alice@example.com",
                "address": {
                    "province": "四川省",
                    "city": "成都市",
                    "zip_code": 610000
                }
            }
            """, "完全正常的数据 + 嵌套完整")
        ]
        
        for (jsonString, description) in edgeCases {
            print("\n🔹 \(description)")
            guard let data = jsonString.data(using: .utf8) else { continue }
            
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                print("   ✅ 解码成功")
                print("     结果: id=\(model.id), age=\(model.age), isActive=\(model.isActive)")
                print("           phone='\(model.phone)', price=\(model.price)")
                print("           optionalName=\(model.optionalName ?? "nil")")
                if let address = model.address {
                    print("           嵌套地址: \(address.province)-\(address.city)-\(address.zipCode)")
                }
            } catch {
                print("   ❌ 解码失败: \(error)")
            }
        }
    }
    
    static func testPerformance() {
        print("\n📊 性能测试:")
        
        let testData = (1...1000).map { index -> String in
            return """
            {
                "id": "\(index)",
                "age": "\(index % 100)",
                "phone": "13800\(String(format: "%06d", index))",
                "score": "\(Double(index) / 10.0)",
                "is_active": "\(index % 2 == 0)",
                "is_premium": "\(index % 3 == 0)",
                "price": "\(Double(index) * 1.5)",
                "rating": "\(Double(index % 5) + 0.5)",
                "optionalName": "User\(index)",
                "optional_value": \(index),
                "name": "User\(index)",
                "email": "user\(index)@example.com",
                "address": {
                    "province": "测试省\(index)",
                    "city": "测试市\(index)",
                    "zip_code": "\(100000 + index)"
                }
            }
            """
        }
        
        var successCount = 0
        let startTime = Date()
        
        for jsonString in testData.prefix(100) {
            guard let data = jsonString.data(using: .utf8) else { continue }
            
            do {
                _ = try JSONDecoder().decode(TestModel.self, from: data)
                successCount += 1
            } catch { }
        }
        
        let timeElapsed = Date().timeIntervalSince(startTime)
        print("   ✅ 成功解码: \(successCount)/100 条数据")
        print("   ⏱️  耗时: \(String(format: "%.3f", timeElapsed)) 秒")
        print("   📈 平均每条: \(String(format: "%.3f", timeElapsed * 1000 / 100)) 毫秒")
    }
}

// MARK: - 实际使用示例（支持自定义结构体DataContent）
struct PracticalExample {
    struct APIResponse: Codable {
        @SafeValue var statusCode: Int = 0
        @SafeValue var message: String = ""
        @SafeValue var data: DataContent? = nil
        
        // 自定义解码：支持缺失字段
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.statusCode = try container.decodeIfPresent(SafeValue<Int>.self, forKey: .statusCode)?.wrappedValue ?? 0
            self.message = try container.decodeIfPresent(SafeValue<String>.self, forKey: .message)?.wrappedValue ?? ""
            self.data = try container.decodeIfPresent(SafeValue<DataContent?>.self, forKey: .data)?.wrappedValue
        }
        
        enum CodingKeys: String, CodingKey {
            case statusCode, message, data
        }
    }
    
    // 自定义结构体：遵守Codable即可，无需额外修改
    struct DataContent: Codable {
        @SafeValue var userId: Int = 0
        @SafeValue var username: String = ""
        @SafeValue var balance: Double = 0.0
        @SafeValue var isVerified: Bool = false
        @SafeValue var createdAt: String = ""
        // 新增：嵌套地址字段
        @SafeValue var address: Address? = nil
        
        // 自定义解码：支持缺失字段 + 嵌套 Model
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.userId = try container.decodeIfPresent(SafeValue<Int>.self, forKey: .userId)?.wrappedValue ?? 0
            self.username = try container.decodeIfPresent(SafeValue<String>.self, forKey: .username)?.wrappedValue ?? ""
            self.balance = try container.decodeIfPresent(SafeValue<Double>.self, forKey: .balance)?.wrappedValue ?? 0.0
            self.isVerified = try container.decodeIfPresent(SafeValue<Bool>.self, forKey: .isVerified)?.wrappedValue ?? false
            self.createdAt = try container.decodeIfPresent(SafeValue<String>.self, forKey: .createdAt)?.wrappedValue ?? ""
            // 新增：解析嵌套地址
            self.address = try container.decodeIfPresent(SafeValue<Address?>.self, forKey: .address)?.wrappedValue
        }
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case username, balance
            case isVerified = "is_verified"
            case createdAt = "created_at"
            case address // 新增嵌套 key
        }
    }
    
    static func simulateAPIResponses() {
        print("\n🚀 模拟实际 API 响应:")
        
        let responses = [
            """
            {
                "statusCode": "200",
                "message": "Success",
                "data": {
                    "user_id": "1001",
                    "username": "john_doe",
                    "balance": "1500.50",
                    "is_verified": "1",
                    "created_at": "2023-01-01T00:00:00Z",
                    "address": {
                        "province": "广东省",
                        "city": "广州市",
                        "zip_code": "510000"
                    }
                }
            }
            """,
            
            """
            {
                "statusCode": 200,
                "message": "Success",
                "data": {
                    "user_id": 1002,
                    "username": "jane_doe",
                    "balance": 2500.75,
                    "is_verified": true,
                    "created_at": 1672531200
                }
            }
            """,
            
            """
            {
                "statusCode": "success",
                "message": 12345,
                "data": {
                    "user_id": "invalid_id",
                    "username": null,
                    "balance": "N/A",
                    "is_verified": "maybe",
                    "created_at": "invalid_date",
                    "address": {
                        "province": 789,
                        "city": "上海市",
                        "zip_code": "abc123"
                    }
                }
            }
            """,
            
            """
            {
                "statusCode": 200,
                "message": "Success"
            }
            """
        ]
        
        for (index, jsonString) in responses.enumerated() {
            print("\n📡 响应 \(index + 1):")
            
            guard let data = jsonString.data(using: .utf8) else {
                print("   ❌ JSON 数据无效")
                continue
            }
            
            do {
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                print("   ✅ 解码成功")
                print("     Status: \(response.statusCode)")
                print("     Message: \(response.message)")
                
                if let data = response.data {
                    print("     User ID: \(data.userId)")
                    print("     Username: \(data.username)")
                    print("     Balance: \(data.balance)")
                    print("     Verified: \(data.isVerified)")
                    print("     Created: \(data.createdAt)")
                    if let address = data.address {
                        print("     Address: \(address.province)-\(address.city)-\(address.zipCode)")
                    }
                } else {
                    print("     Data: nil")
                }
            } catch {
                print("   ❌ 解码失败: \(error)")
            }
        }
    }
}
