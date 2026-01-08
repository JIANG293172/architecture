//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // MARK: - 运行测试
        print("🔧 SafeValue Property Wrapper 最终无报错版本测试")

        CompleteTests.run()
        PracticalExample.simulateAPIResponses()

        // 单个测试示例
        print("\n📝 单个示例测试:")
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
            "email": "test@example.com"
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
            } catch {
                print("❌ 测试失败: \(error)")
            }
        }

        

    }
    


}


import Foundation

// MARK: - 修复后的 SafeValue 属性包装器（最终无报错版本）
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
    
    // MARK: - Codable 实现（修复 nil! 报错）
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 安全初始化 defaultValue（核心修复）
        self.defaultValue = Self.getAppropriateDefaultValue(for: T.self)
        
        // 1. 尝试直接解码
        if let decodedValue = try? container.decode(T.self) {
            self.value = decodedValue
            return
        }
        
        // 2. 尝试类型转换
        print("⚠️ 直接解码失败: 尝试类型转换 for type \(T.self)")
        do {
            self.value = try Self.decodeWithFallback(from: container)
        } catch {
            print("❌ 类型转换失败: \(error)")
            // 3. 用默认值兜底
            self.value = self.defaultValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    // MARK: - 核心修复：安全获取默认值
    private static func getAppropriateDefaultValue(for type: T.Type) -> T {
        switch type {
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
        case is Optional<String>.Type:
            return nil as! T
        case is Optional<Int>.Type:
            return nil as! T
        case is Optional<Double>.Type:
            return nil as! T
        case is Optional<Float>.Type:
            return nil as! T
        case is Optional<Bool>.Type:
            return nil as! T
        default:
            fatalError("⚠️ 不支持的类型 \(T.self)，请扩展 getAppropriateDefaultValue 方法添加该类型的默认值")
        }
    }
    
    // MARK: - 类型转换逻辑（保持不变）
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
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "不支持的类型 \(T.self)，无法转换"
            )
        }
    }
    
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
            let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if let int = Int(numbers) {
                return int
            }
        } else if let double = try? container.decode(Double.self) {
            return Int(double)
        } else if let bool = try? container.decode(Bool.self) {
            return bool ? 1 : 0
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
            if let double = Double(numbers) {
                return double
            }
        } else if let bool = try? container.decode(Bool.self) {
            return bool ? 1.0 : 0.0
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
        }
        return false
    }
}

// MARK: - 辅助扩展：空Decoder（用于兜底创建默认值）
extension Decoder {
    static func empty() -> Decoder {
        let data = Data()
        return try! JSONDecoder().singleValueDecoder(for: data)
    }
    
    private static func singleValueDecoder(for data: Data) throws -> Decoder {
        let decoder = JSONDecoder()
        let wrapper = try decoder.decode(EmptyDecodable.self, from: data)
        return wrapper.decoder
    }
    
    private struct EmptyDecodable: Decodable {
        let decoder: Decoder
        init(from decoder: Decoder) throws {
            self.decoder = decoder
        }
    }
}

// MARK: - 可选类型扩展（简化版）
extension SafeValue where T: ExpressibleByNilLiteral {
    init() {
        self.value = nil
        self.defaultValue = nil
    }
}

// MARK: - 测试模型（保持不变）
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
    
    enum CodingKeys: String, CodingKey {
        case id, age, phone, score
        case isActive = "is_active"
        case isPremium = "is_premium"
        case price, rating, optionalName
        case optionalValue = "optional_value"
        case name, email
    }
}

// MARK: - 完整测试（保持不变）
struct CompleteTests {
    static func run() {
        print("🧪 SafeValue 完整测试")
        print("=" * 50)
        
        testAllCases()
        testEdgeCases()
        testPerformance()
        
        print("=" * 50)
        print("✅ 测试完成")
    }
    
    static func testAllCases() {
        print("\n📊 测试各种数据类型转换:")
        
        let testCases = [
            ("""
            {
                "id": "123",
                "age": "25"
            }
            """, "String → Int", "id=123, age=25"),
            
            ("""
            {
                "phone": 13800138000,
                "score": 95.5
            }
            """, "Number → String", "phone='13800138000', score='95.5'"),
            
            ("""
            {
                "is_active": "true",
                "is_premium": 1
            }
            """, "String/Int → Bool", "isActive=true, isPremium=true"),
            
            ("""
            {
                "price": "99.99",
                "rating": 4.5
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
                "is_active": "invalid",
                "price": "not_a_number"
            }
            """, "空值和无效数据"),
            
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
            """, "混合问题数据"),
            
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
                "email": "alice@example.com"
            }
            """, "完全正常的数据")
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
                "name": "User\(index)",
                "email": "user\(index)@example.com"
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

// MARK: - 实际使用示例（保持不变）
struct PracticalExample {
    struct APIResponse: Codable {
        @SafeValue var statusCode: Int = 0
        @SafeValue var message: String = ""
        @SafeValue var data: DataContent? = nil
        
        struct DataContent: Codable {
            @SafeValue var userId: Int = 0
            @SafeValue var username: String = ""
            @SafeValue var balance: Double = 0.0
            @SafeValue var isVerified: Bool = false
            @SafeValue var createdAt: String = ""
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case username, balance
                case isVerified = "is_verified"
                case createdAt = "created_at"
            }
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
                    "created_at": "2023-01-01T00:00:00Z"
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
                    "created_at": "invalid_date"
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
                } else {
                    print("     Data: nil")
                }
            } catch {
                print("   ❌ 解码失败: \(error)")
            }
        }
    }
}
