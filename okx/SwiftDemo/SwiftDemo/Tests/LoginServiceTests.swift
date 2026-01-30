import XCTest
import Combine
@testable import SwiftDemo

/// LoginService 测试用例
/// 测试登录服务的功能
class LoginServiceTests: XCTestCase {
    
    // MARK: - 测试对象
    private var loginService: LoginService!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - 测试生命周期
    
    /// 每个测试方法执行前调用
    override func setUp() {
        super.setUp()
        // 创建测试对象
        loginService = LoginService()
        cancellables = Set<AnyCancellable>()
    }
    
    /// 每个测试方法执行后调用
    override func tearDown() {
        // 清理测试对象
        loginService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - 测试登录服务
    
    /// 测试登录成功
    func testLoginSuccess() {
        // 设置期望，等待登录完成
        let expectation = XCTestExpectation(description: "登录成功")
        
        // 执行登录
        loginService.login(username: "admin", password: "123456")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("登录流程完成")
                case .failure(let error):
                    XCTFail("登录不应失败: \(error)")
                }
            }, receiveValue: { success in
                print("登录结果: \(success)")
                XCTAssertTrue(success, "正确的用户名和密码应登录成功")
                // 完成期望
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // 等待登录完成
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// 测试登录失败
    func testLoginFailure() {
        // 设置期望，等待登录完成
        let expectation = XCTestExpectation(description: "登录失败")
        
        // 执行登录（使用错误的密码）
        loginService.login(username: "admin", password: "wrongpassword")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("登录流程完成")
                case .failure(let error):
                    XCTFail("登录不应失败: \(error)")
                }
            }, receiveValue: { success in
                print("登录结果: \(success)")
                XCTAssertFalse(success, "错误的密码应登录失败")
                // 完成期望
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // 等待登录完成
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// 测试空用户名登录
    func testLoginWithEmptyUsername() {
        // 设置期望，等待登录完成
        let expectation = XCTestExpectation(description: "登录失败")
        
        // 执行登录（使用空用户名）
        loginService.login(username: "", password: "123456")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("登录流程完成")
                case .failure(let error):
                    XCTFail("登录不应失败: \(error)")
                }
            }, receiveValue: { success in
                print("登录结果: \(success)")
                XCTAssertFalse(success, "空用户名应登录失败")
                // 完成期望
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // 等待登录完成
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// 测试空密码登录
    func testLoginWithEmptyPassword() {
        // 设置期望，等待登录完成
        let expectation = XCTestExpectation(description: "登录失败")
        
        // 执行登录（使用空密码）
        loginService.login(username: "admin", password: "")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("登录流程完成")
                case .failure(let error):
                    XCTFail("登录不应失败: \(error)")
                }
            }, receiveValue: { success in
                print("登录结果: \(success)")
                XCTAssertFalse(success, "空密码应登录失败")
                // 完成期望
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // 等待登录完成
        wait(for: [expectation], timeout: 3.0)
    }
}
