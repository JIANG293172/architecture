import XCTest
import Combine
@testable import SwiftDemo

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
