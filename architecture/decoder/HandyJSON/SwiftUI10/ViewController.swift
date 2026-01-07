import UIKit
import Foundation
import HandyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testHandyJSONOptionalParse()
    }
    
    // 修复：struct 遵循 HandyJSON 并保证默认初始化器存在
    struct TestUser: HandyJSON {
        // 1. 必选字段改为 var + 默认值（核心修复：保证init()存在）
        var id: Int = 0
        var name: String = ""
        
        // 2. 可选字段（容错）
        var age: Int?
        var height: String?
        var isVip: Bool?
        var score: Double?
        
        // 3. 手动实现空初始化（兼容低版本 HandyJSON）
        init() {}
        
        // 可选：自定义字段映射（如果需要）
        mutating func mapping(mapper: HelpingMapper) {
            // 示例：如果后端字段和模型字段不一致，可在这里映射
            // mapper <<< self.name <-- "user_name"
        }
    }
    
    // 对比测试：有默认值的模型
    struct TestUserWithDefault: HandyJSON {
        var id: Int = 0
        var name: String = ""
        var age: Int?
        
        // 手动实现空初始化
        init() {}
    }
    
    // 核心测试方法
    func testHandyJSONOptionalParse() {
        print("========== 测试1：正常数据（所有字段完整）==========")
        let normalDict: [String: Any] = [
            "id": 1001,
            "name": "张三",
            "age": 25,
            "height": 175,
            "isVip": 1,
            "score": 98.5
        ]
        if let user = TestUser.deserialize(from: normalDict) {
            print("解析成功：\nid: \(user.id), name: \(user.name), age: \(user.age ?? -1)")
        } else {
            print("解析失败")
        }
        
        print("\n========== 测试2：可选字段异常（类型不匹配）==========")
        let invalidOptionalDict: [String: Any] = [
            "id": 1002,
            "name": "李四",
            "age": "abc",  // 字符串转Int失败
            "height": 180  // 数字转String成功
        ]
        if let user = TestUser.deserialize(from: invalidOptionalDict) {
            print("解析成功：\nid: \(user.id), name: \(user.name), age: \(user.age ?? -1), height: \(user.height ?? "未知")")
        } else {
            print("解析失败")
        }
        
        print("\n========== 测试3：必选字段缺失（但有默认值）==========")
        let missingRequiredDict: [String: Any] = [
            "name": "王五",
            "age": 28
        ]
        if let user = TestUser.deserialize(from: missingRequiredDict) {
            print("解析成功（用默认值填充）：\nid: \(user.id)（默认0）, name: \(user.name)")
        } else {
            print("解析失败")
        }
        
        print("\n========== 测试4：可选字段完全缺失 ==========")
        let missingOptionalDict: [String: Any] = [
            "id": 1004,
            "name": "钱七"
        ]
        if let user = TestUser.deserialize(from: missingOptionalDict) {
            print("解析成功：\nid: \(user.id), name: \(user.name), age: \(user.age ?? -1)")
        } else {
            print("解析失败")
        }
    }
}
