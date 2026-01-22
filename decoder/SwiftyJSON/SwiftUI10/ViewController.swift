import UIKit
import Foundation
import SwiftyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 执行所有测试场景
        runAllSwiftyJSONTests()
    }
    
    // MARK: - 核心测试方法
    func runAllSwiftyJSONTests() {
        print("🔧 SwiftyJSON 类型容错解析测试")
        print(String(repeating: "=", count: 60))
        
        // 1. 基础类型转换测试（核心场景）
        testBasicTypeConversion()
        
        // 2. 边界场景测试（无效值/空值/字段缺失）
        testEdgeCases()
        
        // 3. 增强版嵌套模型解析测试（重点优化）
        testEnhancedNestedModelParsing()
        
        // 4. 性能简单测试
        testPerformance()
    }
    
    // MARK: - 工具方法：安全解析JSON（核心修复）
    private func safeParseJSON(from jsonString: String) -> JSON {
        // 1. 转换Data
        guard let data = jsonString.data(using: .utf8) else {
            print("❌ JSON字符串转Data失败")
            return JSON() // 返回空JSON
        }
        
        // 2. 安全解析JSON（替换try!为try?，失败返回空JSON）
        do {
            let json = try JSON(data: data)
            return json
        } catch {
            print("❌ JSON解析失败：\(error.localizedDescription)")
            print("❌ 错误详情：\(error)")
            print("❌ 待解析的JSON字符串：\(jsonString)")
            return JSON() // 解析失败返回空JSON，避免崩溃
        }
    }
    
    // MARK: - 1. 基础类型转换测试（核心场景）
    func testBasicTypeConversion() {
        print("\n📌 基础类型转换测试")
        // 修正后的合法JSON：所有Key都是双引号，无语法错误
        let testJSONString = """
        {
            "id": "999",
            "age": 30,
            "phone": 13800138000,
            "score": "99.5",
            "is_vip": "true",
            "balance": 299.99,
            "height": true
        }
        """
        
        // 安全解析JSON（核心修复：改用工具方法）
        let json = safeParseJSON(from: testJSONString)
        
        // 打印原始 JSON 数据（验证解析成功）
        print("📝 原始 JSON 数据：\(json)")
        
        // 解析为模型
        let user = User(from: json)
        
        // 打印结果（验证类型转换）
        print("✅ 解析结果：")
        print("   ID (String→Int): \(user.id)")          // 999
        print("   Age (Int→String): \(user.age)")        // "30"
        print("   Phone (Int→String): \(user.phone)")    // "13800138000"
        print("   Score (String→Double): \(user.score)")  // 99.5
        print("   IsVIP (String→Bool): \(user.isVIP)")    // true
        print("   Balance (Double→Int): \(user.balance)")// 299
        print("   Height (Bool→Double): \(user.height)") // 1.0
    }
    
    // MARK: - 2. 边界场景测试（无效值/空值/字段缺失）
    func testEdgeCases() {
        print("\n📌 边界场景测试（无效值/空值/字段缺失）")
        
        // 修正后的合法JSON
        let edgeCaseJSONString = """
        {
            "id": "一百二十三",
            "age": null,
            "phone": "",
            "score": "非数字",
            "is_vip": "maybe",
            "balance": "999.99a",
            "nickname": true,
            "price": "199.9元"
        }
        """
        
        // 安全解析JSON
        let json = safeParseJSON(from: edgeCaseJSONString)
        
        // 打印原始 JSON 数据
        print("📝 原始 JSON 数据：\(json)")
        
        let user = User(from: json)
        
        print("✅ 边界场景解析结果：")
        print("   ID (无效字符串→Int): \(user.id)")          // 0
        print("   Age (nil→String): \(user.age)")            // ""
        print("   Phone (空字符串→String): \(user.phone)")  // ""
        print("   Score (无效字符串→Double): \(user.score)")// 0.0
        print("   IsVIP (无效字符串→Bool): \(user.isVIP)")  // false
        print("   Balance (乱码→Int): \(user.balance)")     // 0
        print("   Height (字段缺失→Double): \(user.height)")// 0.0
        print("   Nickname (Bool→String): \(user.nickname)")// "true"
        print("   Price (带单位→Double): \(user.price)")    // 199.9
    }
    
    // MARK: - 3. 增强版嵌套模型解析测试（重点）
    func testEnhancedNestedModelParsing() {
        print("\n📌 增强版嵌套模型解析测试（数组+多层嵌套+空值）")
        
        // 修正后的合法JSON（核心：所有Key都是双引号，无语法错误）
        let nestedJSONString = """
        {
            "user_id": "10086",
            "user_name": "李四",
            "main_address": {
                "province": 450000,
                "city": "广州市",
                "detail": {
                    "street": 100,
                    "building": "A栋",
                    "floor": "25层"
                },
                "zip_code": "510000"
            },
            "other_addresses": [
                {
                    "province": "广东省",
                    "city": 755,
                    "zip_code": null
                },
                {
                    "province": null,
                    "city": "上海市",
                    "zip_code": "200000"
                }
            ],
            "empty_addresses": [],
            "invalid_address": null,
            "orders": [
                {
                    "order_id": "20260106",
                    "amount": "999.99元"
                },
                {
                    "order_id": 20260107,
                    "amount": 1999.99
                }
            ]
        }
        """
        
        // 安全解析JSON
        let json = safeParseJSON(from: nestedJSONString)
        
        // 打印原始 JSON 数据（验证解析成功）
        print("📝 原始 JSON 数据：\(json)")
        
        // 解析为复杂嵌套模型
        let complexUser = ComplexUser(from: json)
        
        // 分步打印解析结果
        print("\n✅ 复杂嵌套模型解析结果：")
        // 1. 主模型基础字段
        print("🔹 主模型基础字段：")
        print("   user_id (String→Int): \(complexUser.userId)") // 10086
        print("   user_name: \(complexUser.userName)")         // 李四
        
        // 2. 第一层嵌套（主地址）
        print("\n🔹 第一层嵌套（主地址）：")
        print("   省份(Int→String): \(complexUser.mainAddress.province)")
        print("   城市: \(complexUser.mainAddress.city)")
        // 安全解包：可选链+默认值（避免nil崩溃）
        print("   街道(Int→String): \(complexUser.mainAddress.detail?.street ?? "未知街道")")
        print("   楼栋: \(complexUser.mainAddress.detail?.building ?? "未知楼栋")")
        print("   楼层(String→Int): \(complexUser.mainAddress.detail?.floor ?? 0)")
        print("   邮编(String→Int): \(complexUser.mainAddress.zipCode)")

        // 3. 数组嵌套（其他地址）
        print("\n🔹 数组嵌套（其他地址）：")
        for (index, addr) in complexUser.otherAddresses.enumerated() {
            print("   地址\(index+1)：")
            print("      省份: \(addr.province)")
            print("      城市(Int→String): \(addr.city)")
            print("      邮编(nil→Int): \(addr.zipCode)")
        }
        
        // 4. 空数组/Null节点
        print("\n🔹 空数组/Null节点解析：")
        print("   空地址数组长度: \(complexUser.emptyAddresses.count)")
        print("   无效地址(Null→模型): 省份=\(complexUser.invalidAddress.province), 城市=\(complexUser.invalidAddress.city)")
        
        // 5. 混合类型数组（订单）
        print("\n🔹 混合类型数组（订单）：")
        for (index, order) in complexUser.orders.enumerated() {
            print("   订单\(index+1)：")
            print("      订单ID: \(order.orderId)")
            print("      金额: \(order.amount) 元")
        }
    }
    
    // MARK: - 4. 简单性能测试
    func testPerformance() {
        print("\n📌 简单性能测试（解析100条数据）")
        
        let startTime = Date()
        var successCount = 0
        
        for i in 1...100 {
            let jsonString = """
            {
                "id": "\(i)",
                "age": \(i % 100),
                "phone": 13800\(String(format: "%06d", i)),
                "score": "\(Double(i)/10)",
                "is_vip": \(i % 2 == 0),
                "balance": \(Double(i)*1.5),
                "height": \(i % 5 == 0),
                "price": "\(Double(i)*2)元"
            }
            """
            
            // 安全解析JSON
            let json = safeParseJSON(from: jsonString)
            
            _ = User(from: json)
            successCount += 1
        }
        
        let duration = Date().timeIntervalSince(startTime)
        print("✅ 成功解析: \(successCount)/100 条数据")
        print("⏱️  耗时: \(String(format: "%.3f", duration)) 秒")
    }
}

// MARK: - 基础模型（演示SwiftyJSON类型容错）
struct User {
    let id: Int
    let age: String
    let phone: String
    let score: Double
    let isVIP: Bool
    let balance: Int
    let height: Double
    let nickname: String
    let price: Double
    
    init(from json: JSON) {
        id = json["id"].intValue
        age = json["age"].stringValue
        phone = json["phone"].stringValue
        score = json["score"].doubleValue
        isVIP = json["is_vip"].customBoolValue
        balance = json["balance"].intValue
        height = json["height"].doubleValue
        nickname = json["nickname"].stringValue.isEmpty ? "未知昵称" : json["nickname"].stringValue
        price = json["price"].customDoubleValue
    }
}

// MARK: - 增强版嵌套模型（多层+数组）
struct AddressDetail {
    let street: String
    let building: String
    let floor: Int
    
    init(from json: JSON) {
        street = json["street"].stringValue
        building = json["building"].stringValue
        floor = json["floor"].intValue
    }
}

struct Address {
    let province: String
    let city: String
    let detail: AddressDetail?
    let zipCode: Int
    
    init(from json: JSON) {
        province = json["province"].stringValue
        city = json["city"].stringValue
        detail = json["detail"].exists() ? AddressDetail(from: json["detail"]) : nil
        zipCode = json["zip_code"].intValue
    }
    
    init() {
        province = ""
        city = ""
        detail = nil
        zipCode = 0
    }
}

struct Order {
    let orderId: Int
    let amount: Double
    
    init(from json: JSON) {
        orderId = json["order_id"].intValue
        amount = json["amount"].customDoubleValue
    }
}

struct ComplexUser {
    let userId: Int
    let userName: String
    let mainAddress: Address
    let otherAddresses: [Address]
    let emptyAddresses: [Address]
    let invalidAddress: Address
    let orders: [Order]
    
    init(from json: JSON) {
        userId = json["user_id"].intValue
        userName = json["user_name"].stringValue
        
        // 1. 单层嵌套地址
        mainAddress = Address(from: json["main_address"])
        
        // 2. 数组嵌套地址
        var addresses = [Address]()
        for (_, addrJson) in json["other_addresses"] {
            addresses.append(Address(from: addrJson))
        }
        otherAddresses = addresses
        
        // 3. 空数组
        var emptyAddrs = [Address]()
        for (_, addrJson) in json["empty_addresses"] {
            emptyAddrs.append(Address(from: addrJson))
        }
        emptyAddresses = emptyAddrs
        
        // 4. null节点
        invalidAddress = json["invalid_address"].exists() ? Address(from: json["invalid_address"]) : Address()
        
        // 5. 订单数组
        var orders = [Order]()
        for (_, orderJson) in json["orders"] {
            orders.append(Order(from: orderJson))
        }
        self.orders = orders
    }
}

// MARK: - String扩展：批量替换多个子串
extension String {
    func replacingOccurrences(of substrings: [String], with replacement: String, options: String.CompareOptions = []) -> String {
        var result = self
        for substring in substrings {
            result = result.replacingOccurrences(of: substring, with: replacement, options: options)
        }
        return result
    }
}

// MARK: - SwiftyJSON扩展
extension JSON {
    var customDoubleValue: Double {
        let rawString = self.stringValue
            .replacingOccurrences(of: ["元", "¥", " ", "%"], with: "", options: .caseInsensitive)
        return Double(rawString) ?? 0.0
    }
    
    var customBoolValue: Bool {
        let lowerStr = self.stringValue.lowercased()
        if ["true", "yes", "1", "on", "enabled"].contains(lowerStr) {
            return true
        } else if ["false", "no", "0", "off", "disabled"].contains(lowerStr) {
            return false
        }
        return self.boolValue
    }
    
    func exists() -> Bool {
        return self.type != .null && self.type != .unknown
    }
}
