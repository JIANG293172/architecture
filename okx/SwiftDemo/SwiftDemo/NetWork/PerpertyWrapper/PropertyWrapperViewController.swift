//
//  PropertyWrapperViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/28.
//

import UIKit
import Foundation

/// PropertyWrapper 演示视图控制器
/// 展示 SafeValue Property Wrapper 的最佳实践
class PropertyWrapperViewController: UIViewController {
    
    /// 测试结果显示标签
    private let resultLabel = UILabel()
    /// 运行测试按钮
    private let runTestButton = UIButton(type: .system)
    /// 清空日志按钮
    private let clearLogButton = UIButton(type: .system)
    /// 日志文本视图
    private let logTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PropertyWrapper"
        view.backgroundColor = .white
        setupUI()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置结果标签
        resultLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        resultLabel.textColor = .systemBlue
        resultLabel.numberOfLines = 0
        view.addSubview(resultLabel)
        
        // 设置运行测试按钮
        runTestButton.frame = CGRect(x: 20, y: 160, width: view.frame.width - 40, height: 44)
        runTestButton.setTitle("运行测试", for: .normal)
        runTestButton.setTitleColor(.white, for: .normal)
        runTestButton.backgroundColor = .systemBlue
        runTestButton.layer.cornerRadius = 22
        runTestButton.addTarget(self, action: #selector(runTestButtonTapped), for: .touchUpInside)
        view.addSubview(runTestButton)
        
        // 设置清空日志按钮
        clearLogButton.frame = CGRect(x: 20, y: 220, width: view.frame.width - 40, height: 44)
        clearLogButton.setTitle("清空日志", for: .normal)
        clearLogButton.setTitleColor(.white, for: .normal)
        clearLogButton.backgroundColor = .systemGray
        clearLogButton.layer.cornerRadius = 22
        clearLogButton.addTarget(self, action: #selector(clearLogButtonTapped), for: .touchUpInside)
        view.addSubview(clearLogButton)
        
        // 设置日志文本视图
        logTextView.frame = CGRect(x: 20, y: 280, width: view.frame.width - 40, height: view.frame.height - 300)
        logTextView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        logTextView.textColor = .black
        logTextView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        logTextView.isEditable = false
        logTextView.layer.borderWidth = 1.0
        logTextView.layer.borderColor = UIColor.gray.cgColor
        logTextView.layer.cornerRadius = 8.0
        logTextView.text = "日志输出：\n"
        view.addSubview(logTextView)
    }
    
    /// 运行测试按钮点击事件
    @objc private func runTestButtonTapped() {
        runTests()
    }
    
    /// 清空日志按钮点击事件
    @objc private func clearLogButtonTapped() {
        logTextView.text = "日志输出：\n"
        resultLabel.text = "准备就绪"
    }
    
    /// 运行所有测试
    private func runTests() {
        clearLog()
        appendLog("🔧 SafeValue Property Wrapper 最佳实践测试")
        appendLog(String(repeating: "=", count: 50))
        
        // 测试1：基础类型转换
        testBasicTypeConversion()
        
        // 测试2：嵌套模型解析
        testNestedModelParsing()
        
        // 测试3：缺失字段处理
        testMissingFields()
        
        // 测试4：类型错误处理
        testTypeErrors()
        
        // 测试5：实际应用场景
        testPracticalScenario()
        
        resultLabel.text = "✅ 测试完成"
    }
    
    /// 清空日志
    private func clearLog() {
        logTextView.text = "日志输出：\n"
    }
    
    /// 追加日志到文本视图
    private func appendLog(_ log: String) {
        DispatchQueue.main.async {
            self.logTextView.text += log + "\n"
            self.scrollToBottom()
        }
    }
    
    /// 滚动到底部
    private func scrollToBottom() {
        let textCount = logTextView.text.count
        if textCount > 0 {
            let bottom = NSMakeRange(textCount - 1, 1)
            logTextView.scrollRangeToVisible(bottom)
        }
    }
    
    // MARK: - 测试方法
    
    /// 测试基础类型转换
    private func testBasicTypeConversion() {
        appendLog("\n📝 测试1：基础类型转换")
        
        let json = """
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
        
        if let data = json.data(using: .utf8) {
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                appendLog("✅ 测试通过!")
                appendLog("   ID (String→Int): \(model.id)")
                appendLog("   Phone (Int→String): \(model.phone)")
                appendLog("   Is Active (String→Bool): \(model.isActive)")
                appendLog("   Price (String→Double): \(model.price)")
                appendLog("   Rating (Int→Double): \(model.rating)")
            } catch {
                appendLog("❌ 测试失败: \(error)")
            }
        }
    }
    
    /// 测试嵌套模型解析
    private func testNestedModelParsing() {
        appendLog("\n📝 测试2：嵌套模型解析")
        
        let json = """
        {
            "id": "1001",
            "name": "张三",
            "address": {
                "province": "广东省",
                "city": "深圳市",
                "zip_code": "518000"
            }
        }
        """
        
        if let data = json.data(using: .utf8) {
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                appendLog("✅ 测试通过!")
                appendLog("   主模型 ID: \(model.id)")
                appendLog("   主模型 Name: \(model.name)")
                if let address = model.address {
                    appendLog("   省份: \(address.province)")
                    appendLog("   城市: \(address.city)")
                    appendLog("   邮编 (String→Int): \(address.zipCode)")
                }
            } catch {
                appendLog("❌ 测试失败: \(error)")
            }
        }
    }
    
    /// 测试缺失字段处理
    private func testMissingFields() {
        appendLog("\n📝 测试3：缺失字段处理")
        
        let json = """
        {
            "id": "1002",
            "name": "李四"
        }
        """
        
        if let data = json.data(using: .utf8) {
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                appendLog("✅ 测试通过!")
                appendLog("   主模型 ID: \(model.id)")
                appendLog("   主模型 Name: \(model.name)")
                appendLog("   Address: \(model.address?.description ?? "nil (使用默认值)")")
                appendLog("   Phone: \(model.phone) (使用默认值)")
            } catch {
                appendLog("❌ 测试失败: \(error)")
            }
        }
    }
    
    /// 测试类型错误处理
    private func testTypeErrors() {
        appendLog("\n📝 测试4：类型错误处理")
        
        let json = """
        {
            "id": "1003",
            "name": "王五",
            "address": {
                "province": 123,
                "city": true,
                "zip_code": "abc"
            }
        }
        """
        
        if let data = json.data(using: .utf8) {
            do {
                let model = try JSONDecoder().decode(TestModel.self, from: data)
                appendLog("✅ 测试通过!")
                appendLog("   主模型 ID: \(model.id)")
                if let address = model.address {
                    appendLog("   省份 (Int→String): \(address.province)")
                    appendLog("   城市 (Bool→String): \(address.city)")
                    appendLog("   邮编 (String→Int): \(address.zipCode)")
                }
            } catch {
                appendLog("❌ 测试失败: \(error)")
            }
        }
    }
    
    /// 测试实际应用场景
    private func testPracticalScenario() {
        appendLog("\n📝 测试5：实际应用场景")
        
        let json = """
        {
            "user_id": "12345",
            "username": "testuser",
            "balance": "1000.50",
            "is_vip": "1",
            "login_count": 5,
            "last_login": "2024-01-01"
        }
        """
        
        if let data = json.data(using: .utf8) {
            do {
                let userModel = try JSONDecoder().decode(UserModel.self, from: data)
                appendLog("✅ 测试通过!")
                appendLog("   用户ID: \(userModel.userId)")
                appendLog("   用户名: \(userModel.username)")
                appendLog("   余额: \(userModel.balance)")
                appendLog("   VIP状态: \(userModel.isVip)")
                appendLog("   登录次数: \(userModel.loginCount)")
                appendLog("   最后登录: \(userModel.lastLogin)")
            } catch {
                appendLog("❌ 测试失败: \(error)")
            }
        }
    }
}

// MARK: - SafeValue Property Wrapper

/// SafeValue Property Wrapper
/// 功能：
/// 1. 安全的类型转换（String → Int/Double/Bool，Int → String/Double，Double → String/Int，Bool → String）
/// 2. 缺失字段时使用默认值
/// 3. 类型错误时使用默认值
/// 4. 支持Codable协议
/// 5. 支持嵌套模型解析
@propertyWrapper
struct SafeValue<T: Codable>: Codable {
    private var value: T
    private let defaultValue: T
    
    var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    init(defaultValue: T) {
        self.value = defaultValue
        self.defaultValue = defaultValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 获取默认值
        defaultValue = Self.getAppropriateDefaultValue(for: T.self)
        
        do {
            // 尝试直接解码
            value = try container.decode(T.self)
        } catch {
            // 解码失败，尝试类型转换
            if let convertedValue = try? Self.convert(from: container, to: T.self) {
                value = convertedValue
            } else {
                // 转换失败，使用默认值
                value = defaultValue
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    /// 从容器中转换值到指定类型
    private static func convert<T: Codable>(from container: SingleValueDecodingContainer, to type: T.Type) throws -> T {
        // 尝试各种类型转换
        if let stringValue = try? container.decode(String.self) {
            return try convertFromString(stringValue, to: type)
        } else if let intValue = try? container.decode(Int.self) {
            return try convertFromInt(intValue, to: type)
        } else if let doubleValue = try? container.decode(Double.self) {
            return try convertFromDouble(doubleValue, to: type)
        } else if let boolValue = try? container.decode(Bool.self) {
            return try convertFromBool(boolValue, to: type)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "无法转换类型")
        }
    }
    
    /// 从字符串转换到其他类型
    private static func convertFromString<T: Codable>(_ string: String, to type: T.Type) throws -> T {
        if type is Int.Type {
            return (Int(string) ?? 0) as! T
        } else if type is Double.Type {
            return (Double(string) ?? 0.0) as! T
        } else if type is Bool.Type {
            let lowercased = string.lowercased()
            if lowercased == "true" || lowercased == "1" || lowercased == "yes" {
                return true as! T
            } else if lowercased == "false" || lowercased == "0" || lowercased == "no" {
                return false as! T
            } else {
                return false as! T
            }
        } else {
            return string as! T
        }
    }
    
    /// 从整数转换到其他类型
    private static func convertFromInt<T: Codable>(_ int: Int, to type: T.Type) throws -> T {
        if type is String.Type {
            return "\(int)" as! T
        } else if type is Double.Type {
            return Double(int) as! T
        } else if type is Bool.Type {
            return (int != 0) as! T
        } else {
            return int as! T
        }
    }
    
    /// 从浮点数转换到其他类型
    private static func convertFromDouble<T: Codable>(_ double: Double, to type: T.Type) throws -> T {
        if type is String.Type {
            return "\(double)" as! T
        } else if type is Int.Type {
            return Int(double) as! T
        } else if type is Bool.Type {
            return (double != 0.0) as! T
        } else {
            return double as! T
        }
    }
    
    /// 从布尔值转换到其他类型
    private static func convertFromBool<T: Codable>(_ bool: Bool, to type: T.Type) throws -> T {
        if type is String.Type {
            return "\(bool)" as! T
        } else if type is Int.Type {
            return (bool ? 1 : 0) as! T
        } else if type is Double.Type {
            return (bool ? 1.0 : 0.0) as! T
        } else {
            return bool as! T
        }
    }
    
    /// 获取适当的默认值
    private static func getAppropriateDefaultValue<T>(for type: T.Type) -> T {
        switch type {
        case is Int.Type:
            return 0 as! T
        case is Double.Type:
            return 0.0 as! T
        case is String.Type:
            return "" as! T
        case is Bool.Type:
            return false as! T
        case is [String].Type:
            return [] as! T
        case is [Int].Type:
            return [] as! T
        case is [Double].Type:
            return [] as! T
        case is [Bool].Type:
            return [] as! T
        case is [Any].Type:
            return [] as! T
        case is [String: Any].Type:
            return [:] as! T
        default:
            // 对于其他类型，尝试通过反射创建默认值
            if let defaultConstructor = T.self as? ExpressibleByNilLiteral.Type {
                return (defaultConstructor.init(nilLiteral: ()) as! T)
            } else {
                // 作为最后的尝试，返回一个空实例（可能会失败）
                fatalError("无法为类型 \(T.self) 生成默认值")
            }
        }
    }
}

// MARK: - 测试模型

/// 地址模型
struct AddressModel: Codable {
    @SafeValue(defaultValue: "") var province: String
    @SafeValue(defaultValue: "") var city: String
    @SafeValue(defaultValue: 0) var zipCode: Int
    
    enum CodingKeys: String, CodingKey {
        case province
        case city
        case zipCode = "zip_code"
    }
    
    var description: String {
        return "Address(province: \(province), city: \(city), zipCode: \(zipCode))"
    }
}

/// 测试模型
struct TestModel: Codable {
    @SafeValue(defaultValue: 0) var id: Int
    @SafeValue(defaultValue: "") var name: String
    @SafeValue(defaultValue: nil) var address: AddressModel?
    @SafeValue(defaultValue: "") var phone: String
    @SafeValue(defaultValue: 0) var age: Int
    @SafeValue(defaultValue: 0.0) var score: Double
    @SafeValue(defaultValue: false) var isActive: Bool
    @SafeValue(defaultValue: false) var isPremium: Bool
    @SafeValue(defaultValue: 0.0) var price: Double
    @SafeValue(defaultValue: 0.0) var rating: Double
    @SafeValue(defaultValue: "") var email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case phone
        case age
        case score
        case isActive = "is_active"
        case isPremium = "is_premium"
        case price
        case rating
        case email
    }
}

/// 用户模型
struct UserModel: Codable {
    @SafeValue(defaultValue: "") var userId: String
    @SafeValue(defaultValue: "") var username: String
    @SafeValue(defaultValue: 0.0) var balance: Double
    @SafeValue(defaultValue: false) var isVip: Bool
    @SafeValue(defaultValue: 0) var loginCount: Int
    @SafeValue(defaultValue: "") var lastLogin: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case balance
        case isVip = "is_vip"
        case loginCount = "login_count"
        case lastLogin = "last_login"
    }
}
