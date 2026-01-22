import UIKit
import Foundation
// 核心：正确导入社区版 CodableWrappers
import CodableWrappers

// MARK: - 1. 测试模型（使用社区版 CodableWrappers 正确语法）
struct CodableWrapperTestModel: Codable {
    // 1. 基础默认值（核心容错）
    @CodableDefault(.zero) var prop0: Int                // Int 默认 0
    @CodableDefault(.emptyString) var prop1: String      // String 默认 ""
    @CodableDefault(.zero) var prop2: Double             // Double 默认 0.0
    @CodableDefault(.false) var prop3: Bool              // Bool 默认 false
    @CodableDefault(.value(100)) var prop4: Int          // Int 自定义默认值 100
    @CodableDefault(.value("默认文案")) var prop5: String // String 自定义默认值
    @CodableDefault(.value(99.9)) var prop6: Double      // Double 自定义默认值
    @CodableDefault(.true) var prop7: Bool               // Bool 默认 true
    
    // 2. 扩展：空字符串自动转为 nil
    @CodableDefault(.emptyStringToNil) var optionalProp: String?
    
    // 3. 扩展：容错类型转换（如 String → Int，失败则用默认值 0）
    @LossyDecodable var stringToInt: Int
}

// MARK: - 2. 测试工具类
class CodableWrapperTester {
    /// 生成含非法值的测试JSON（模拟真实场景的异常数据）
    static func generateTestJSONData() -> Data {
        let jsonDict: [String: Any] = [
            "prop0": "非数字",       // Int 字段传字符串 → 用默认值 0
            "prop1": 12345,          // String 字段传数字 → 用默认值 ""
            "prop2": "非浮点",       // Double 字段传字符串 → 用默认值 0.0
            "prop3": 666,            // Bool 字段传数字 → 用默认值 false
            "optionalProp": "",      // 空字符串 → 转为 nil
            "stringToInt": "999"     // String → Int → 999（转换成功）
            // prop4-prop7 故意缺失 → 用自定义默认值
        ]
        return try! JSONSerialization.data(withJSONObject: jsonDict)
    }
    
    /// 测试容错能力（核心验证）
    static func testFaultTolerance() {
        print("\n📝 CodableWrappers 容错测试结果：")
        let data = generateTestJSONData()
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(CodableWrapperTestModel.self, from: data)
            print("prop0（Int，非法值→默认0）：\(model.prop0)")
            print("prop1（String，非法值→默认\"\"）：\(model.prop1)")
            print("prop4（Int，缺失→自定义默认100）：\(model.prop4)")
            print("prop5（String，缺失→自定义默认\"默认文案\"）：\(model.prop5)")
            print("prop6（Double，缺失→自定义默认99.9）：\(model.prop6)")
            print("optionalProp（空字符串→nil）：\(model.optionalProp ?? "nil")")
            print("stringToInt（\"999\"→999）：\(model.stringToInt)")
        } catch {
            print("❌ 解析失败：\(error.localizedDescription)")
        }
    }
    
    /// 性能测试（100条数据）
    static func testPerformance() -> Double {
        let decoder = JSONDecoder()
        // 生成100条测试数据
        let datas = (0..<100).map { _ in generateTestJSONData() }
        
        // 记录耗时
        let startTime = CFAbsoluteTimeGetCurrent()
        for data in datas {
            _ = try? decoder.decode(CodableWrapperTestModel.self, from: data)
        }
        let duration = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
        
        print("\n✅ CodableWrappers 解析100条数据耗时：\(String(format: "%.2f", duration)) ms")
        return duration
    }
}

// MARK: - 3. ViewController 整合
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 运行测试（容错+性能）
        CodableWrapperTester.testFaultTolerance()
        _ = CodableWrapperTester.testPerformance()
    }
}
