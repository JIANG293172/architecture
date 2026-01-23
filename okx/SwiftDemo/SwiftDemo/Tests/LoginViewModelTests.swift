import XCTest
@testable import SwiftDemo

/// LoginViewModel 测试用例
/// 测试 LoginViewModel 的基本功能，包括输入验证、登录流程等
class LoginViewModelTests: XCTestCase {
    
    // MARK: - 测试对象
    private var viewModel: LoginViewModel!
    
    // MARK: - 测试生命周期
    
    /// 每个测试方法执行前调用
    override func setUp() {
        super.setUp()
        // 创建测试对象
        viewModel = LoginViewModel()
    }
    
    /// 每个测试方法执行后调用
    override func tearDown() {
        // 清理测试对象
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - 基础测试
    
    /// 测试初始状态
    func testInitialState() {
        // 验证初始状态下的属性值
        XCTAssertEqual(viewModel.username, "", "初始用户名应为空字符串")
        XCTAssertEqual(viewModel.password, "", "初始密码应为空字符串")
        XCTAssertFalse(viewModel.isLoading, "初始加载状态应为 false")
        XCTAssertEqual(viewModel.errorMessage, "", "初始错误信息应为空字符串")
        XCTAssertFalse(viewModel.isLoggedIn, "初始登录状态应为 false")
        XCTAssertFalse(viewModel.isLoginButtonEnabled, "初始登录按钮应禁用")
    }
    
    /// 测试登录按钮启用状态
    func testLoginButtonEnabledState() {
        // 测试空输入时按钮禁用
        viewModel.username = ""
        viewModel.password = ""
        XCTAssertFalse(viewModel.isLoginButtonEnabled, "空输入时登录按钮应禁用")
        
        // 测试只有用户名时按钮禁用
        viewModel.username = "admin"
        viewModel.password = ""
        XCTAssertFalse(viewModel.isLoginButtonEnabled, "只有用户名时登录按钮应禁用")
        
        // 测试只有密码时按钮禁用
        viewModel.username = ""
        viewModel.password = "123456"
        XCTAssertFalse(viewModel.isLoginButtonEnabled, "只有密码时登录按钮应禁用")
        
        // 测试用户名和密码都有值时按钮启用
        viewModel.username = "admin"
        viewModel.password = "123456"
        XCTAssertTrue(viewModel.isLoginButtonEnabled, "用户名和密码都有值时登录按钮应启用")
        
        // 测试加载中时按钮禁用
        viewModel.username = "admin"
        viewModel.password = "123456"
        viewModel.isLoading = true
        XCTAssertFalse(viewModel.isLoginButtonEnabled, "加载中时登录按钮应禁用")
    }
    
    /// 测试输入变化时错误信息清空
    func testErrorMessageClearsOnInputChange() {
        // 设置错误信息
        viewModel.errorMessage = "测试错误信息"
        XCTAssertEqual(viewModel.errorMessage, "测试错误信息", "错误信息应设置成功")
        
        // 修改用户名，验证错误信息清空
        viewModel.username = "admin"
        XCTAssertEqual(viewModel.errorMessage, "", "修改用户名时错误信息应清空")
        
        // 重新设置错误信息
        viewModel.errorMessage = "测试错误信息"
        XCTAssertEqual(viewModel.errorMessage, "测试错误信息", "错误信息应设置成功")
        
        // 修改密码，验证错误信息清空
        viewModel.password = "123456"
        XCTAssertEqual(viewModel.errorMessage, "", "修改密码时错误信息应清空")
    }
    
    // MARK: - 登录流程测试
    
    /// 测试登录方法（异步测试）
    func testLogin() {
        // 设置期望，等待异步操作完成
        let expectation = XCTestExpectation(description: "登录完成")
        
        // 设置登录信息
        viewModel.username = "admin"
        viewModel.password = "123456"
        
        // 执行登录
        viewModel.login()
        
        // 验证加载状态
        XCTAssertTrue(viewModel.isLoading, "登录开始时加载状态应为 true")
        
        // 等待登录完成（模拟网络请求需要时间）
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            // 验证加载状态
            XCTAssertFalse(self.viewModel.isLoading, "登录完成后加载状态应为 false")
            
            // 验证登录状态
            XCTAssertTrue(self.viewModel.isLoggedIn, "正确的用户名和密码应登录成功")
            
            // 验证错误信息
            XCTAssertEqual(self.viewModel.errorMessage, "", "登录成功后错误信息应为空")
            
            // 完成期望
            expectation.fulfill()
        }
        
        // 等待期望完成，超时时间为 3 秒
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// 测试登录失败场景
    func testLoginFailure() {
        // 设置期望，等待异步操作完成
        let expectation = XCTestExpectation(description: "登录失败")
        
        // 设置错误的登录信息
        viewModel.username = "wrong"
        viewModel.password = "wrong"
        
        // 执行登录
        viewModel.login()
        
        // 验证加载状态
        XCTAssertTrue(viewModel.isLoading, "登录开始时加载状态应为 true")
        
        // 等待登录完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            // 验证加载状态
            XCTAssertFalse(self.viewModel.isLoading, "登录完成后加载状态应为 false")
            
            // 验证登录状态
            XCTAssertFalse(self.viewModel.isLoggedIn, "错误的用户名和密码应登录失败")
            
            // 验证错误信息
            XCTAssertEqual(self.viewModel.errorMessage, "用户名或密码错误", "登录失败后应显示错误信息")
            
            // 完成期望
            expectation.fulfill()
        }
        
        // 等待期望完成，超时时间为 3 秒
        wait(for: [expectation], timeout: 3.0)
    }
}
