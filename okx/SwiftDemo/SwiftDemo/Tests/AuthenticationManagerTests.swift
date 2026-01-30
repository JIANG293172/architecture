import XCTest
import Combine
@testable import SwiftDemo

//XCTest 常用 API 整理（作用 + 触发失败条件）
//以下表格覆盖 XCTest 最核心的断言 / 辅助 API，按「基础断言」「数值断言」「集合 / 可选型断言」「流程控制」分类，清晰标注每个 API 的核心作用和触发测试失败的条件，适配 iOS/macOS 测试场景：
//分类    API 名称    核心作用    触发失败的条件
//基础断言    XCTAssert(condition, _ message:)    验证任意布尔条件为 true（最通用断言）    condition 为 false 时失败
//XCTAssertTrue(condition, _ message:)    显式验证条件为 true（语义更清晰）    condition 为 false 时失败
//XCTAssertFalse(condition, _ message:)    验证条件为 false    condition 为 true 时失败
//XCTFail(_ message:)    主动触发测试失败（无前置条件）    只要执行到该代码，测试立即失败
//数值断言    XCTAssertEqual(a, b, _ message:)    验证两个值相等（支持 Equatable 类型：Int/String/ 枚举等）    a != b 时失败（如 1 != 2、.authenticating != .failed）
//XCTAssertNotEqual(a, b, _ message:)    验证两个值不相等    a == b 时失败
//XCTAssertGreaterThan(a, b, _ message:)    验证 a > b（支持 Comparable 类型：Int/Float/Double 等）    a ≤ b 时失败（如 0 > 0、5 > 10）
//XCTAssertGreaterThanOrEqual(a, b, _)    验证 a ≥ b    a < b 时失败
//XCTAssertLessThan(a, b, _ message:)    验证 a < b    a ≥ b 时失败
//XCTAssertLessThanOrEqual(a, b, _)    验证 a ≤ b    a > b 时失败
//XCTAssertEqualWithAccuracy(a, b, accuracy:)    验证浮点型值近似相等（解决精度问题，如 0.1+0.2≠0.3）    `    a - b    > accuracy时失败（如accuracy=0.001，0.3001 ≠ 0.3`）
//集合 / 可选型断言    XCTAssertNil(optional, _ message:)    验证可选型为 nil    可选型有值（如 Optional("test")）时失败
//XCTAssertNotNil(optional, _ message:)    验证可选型非 nil    可选型为 nil 时失败
//XCTAssertEmpty(collection, _ message:)    验证集合（Array/Dictionary/Set）为空（需导入 XCTestExtensions）    集合 count > 0 时失败
//XCTAssertNotEmpty(collection, _ message:)    验证集合非空    集合 count == 0 时失败
//XCTAssertContains(collection, element, _)    验证集合包含指定元素（需导入 XCTestExtensions）    集合中无该元素时失败
//错误 / 异常断言    XCTAssertThrowsError(expression, _ message:)    验证代码块抛出异常    代码块未抛出任何异常时失败
//XCTAssertNoThrow(expression, _ message:)    验证代码块不抛出异常    代码块抛出任意异常时失败
//XCTAssertThrowsError(expression) { error in ... }    验证抛出指定类型 / 内容的异常    未抛出异常，或抛出的异常与预期类型 / 内容不符时失败
//流程控制 / 辅助    XCTContext.runActivity(named: _ block:)    给测试步骤分组，添加子任务 / 附件（用于测试报告）    本身不触发失败，仅用于增强测试报告可读性
//XCTAttachment(content:)    给测试添加附件（如日志、截图、数据文件）    本身不触发失败，附件会显示在测试报告中
//XCTWaiter().wait(for:timeout:)    等待异步任务完成（如网络请求、回调）    超时未满足等待条件（如 expectation.fulfill() 未执行）时失败

/// AuthenticationManager 测试用例
/// 测试 PassthroughSubject 的使用和认证流程
class AuthenticationManagerTests: XCTestCase {
    
    // MARK: - 测试对象
    private var authManager: AuthenticationManager!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - 测试生命周期
    
    /// 每个测试方法执行前调用
    override func setUp() {
        super.setUp()
        // 创建测试对象
        authManager = AuthenticationManager()
        cancellables = Set<AnyCancellable>()
    }
    
    /// 每个测试方法执行后调用
    override func tearDown() {
        // 清理测试对象
        authManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - 测试 PassthroughSubject
    
    /// 测试登录成功流程
    func testLoginSuccess() {
        // 设置期望，等待认证流程完成
        let expectation = XCTestExpectation(description: "登录成功")
        
        // 监听认证状态变化
        var receivedStatuses: [AuthenticationManager.AuthStatus] = []
        
        authManager.authStatusSubject
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("认证流程完成")
                case .failure(let error):
                    XCTFail("认证流程不应失败: \(error)")
                }
                // 完成期望
                expectation.fulfill()
            }, receiveValue: { status in
                print("收到认证状态: \(status)")
                receivedStatuses.append(status)
            })
            .store(in: &cancellables)
        
        // 执行登录
        authManager.login(username: "admin", password: "123456")
        
        // 等待认证完成
        wait(for: [expectation], timeout: 3.0)
        
        // 验证收到的状态
        XCTAssertGreaterThan(receivedStatuses.count, 0, "应至少收到一个认证状态")
        
        // 验证第一个状态是 authenticating
        if let firstStatus = receivedStatuses.first {
            switch firstStatus {
            case .authenticating:
                XCTAssertTrue(true, "第一个状态应为 authenticating")
            default:
                XCTFail("第一个状态应为 authenticating，实际为: \(firstStatus)")
            }
        } else {
            XCTFail("未收到任何认证状态")
        }
        
        // 验证最后一个状态是 authenticated
        if let lastStatus = receivedStatuses.last {
            switch lastStatus {
            case .authenticated(let userID):
                XCTAssertEqual(userID, "user_123", "用户ID应为 user_123")
            default:
                XCTFail("最后一个状态应为 authenticated，实际为: \(lastStatus)")
            }
        } else {
            XCTFail("未收到任何认证状态")
        }
    }
    
    /// 测试登录失败流程
    func testLoginFailure() {
        // 设置期望，等待认证流程完成
        let expectation = XCTestExpectation(description: "登录失败")
        
        // 监听认证状态变化
        var receivedStatuses: [AuthenticationManager.AuthStatus] = []
        
        authManager.authStatusSubject
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("认证流程完成")
                case .failure(let error):
                    XCTFail("认证流程不应失败: \(error)")
                }
                // 完成期望
                expectation.fulfill()
            }, receiveValue: { status in
                print("收到认证状态: \(status)")
                receivedStatuses.append(status)
            })
            .store(in: &cancellables)
        
        // 执行登录（使用错误的密码）
        authManager.login(username: "admin", password: "wrongpassword")
        
        // 等待认证完成
        wait(for: [expectation], timeout: 3.0)
        
        // 验证收到的状态
        XCTAssertGreaterThan(receivedStatuses.count, 0, "应至少收到一个认证状态")
        
        // 验证第一个状态是 authenticating
        if let firstStatus = receivedStatuses.first {
            switch firstStatus {
            case .authenticating:
                XCTAssertTrue(true, "第一个状态应为 authenticating")
            default:
                XCTFail("第一个状态应为 authenticating，实际为: \(firstStatus)")
            }
        } else {
            XCTFail("未收到任何认证状态")
        }
        
        // 验证最后一个状态是 authenticationFailed
        if let lastStatus = receivedStatuses.last {
            switch lastStatus {
            case .authenticationFailed(let error):
                XCTAssertEqual(error, "用户名或密码错误", "错误信息应为 '用户名或密码错误'")
            default:
                XCTFail("最后一个状态应为 authenticationFailed，实际为: \(lastStatus)")
            }
        } else {
            XCTFail("未收到任何认证状态")
        }
    }
    
    /// 测试登出流程
    func testLogout() {
        // 设置期望，等待认证流程完成
        let expectation = XCTestExpectation(description: "登出完成")
        
        // 监听认证状态变化
        var receivedStatuses: [AuthenticationManager.AuthStatus] = []
        
        authManager.authStatusSubject
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("认证流程完成")
                case .failure(let error):
                    XCTFail("认证流程不应失败: \(error)")
                }
                // 完成期望
                expectation.fulfill()
            }, receiveValue: { status in
                print("收到认证状态: \(status)")
                receivedStatuses.append(status)
            })
            .store(in: &cancellables)
        
        // 执行登出
        authManager.logout()
        
        // 等待登出完成
        wait(for: [expectation], timeout: 1.0)
        
        // 验证收到的状态
        XCTAssertEqual(receivedStatuses.count, 1, "应收到一个认证状态")
        
        // 验证状态是 unauthenticated
        if let status = receivedStatuses.first {
            switch status {
            case .unauthenticated:
                XCTAssertTrue(true, "登出后状态应为 unauthenticated")
            default:
                XCTFail("登出后状态应为 unauthenticated，实际为: \(status)")
            }
        } else {
            XCTFail("未收到任何认证状态")
        }
    }
}
