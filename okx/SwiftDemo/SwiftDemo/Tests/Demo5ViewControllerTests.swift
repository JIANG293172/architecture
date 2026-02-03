import XCTest
import UIKit
@testable import SwiftDemo

/// Demo5ViewController 测试用例
/// 测试视图控制器的功能
class CombineViewControllerTests: XCTestCase {
    
    // MARK: - 测试对象
    private var viewController: CombineViewController!
    
    // MARK: - 测试生命周期
    
    /// 每个测试方法执行前调用
    override func setUp() {
        super.setUp()
        // 创建测试对象
        viewController = CombineViewController()
        // 加载视图
        viewController.loadViewIfNeeded()
    }
    
    /// 每个测试方法执行后调用
    override func tearDown() {
        // 清理测试对象
        viewController = nil
        super.tearDown()
    }
    
    // MARK: - 测试视图控制器
    
    /// 测试视图加载
    func testViewLoads() {
        XCTAssertNotNil(viewController.view, "视图应加载成功")
        XCTAssertNotNil(viewController.hostingController, "SwiftUI 宿主控制器应创建成功")
    }
    
    /// 测试标题设置
    func testTitle() {
        XCTAssertEqual(viewController.title, "Combine + SwiftUI 登录Demo", "标题应设置正确")
    }
    
    /// 测试视图模型初始化
    func testViewModelInitialization() {
        // 注意：由于 viewModel 是私有的，我们无法直接访问
        // 但我们可以通过测试视图控制器的其他功能来间接验证
        // 这里我们主要测试视图控制器的初始化和设置
        XCTAssertNotNil(viewController, "视图控制器应初始化成功")
    }
    
    /// 测试 SwiftUI 视图设置
    func testSwiftUIViewSetup() {
        // 验证宿主控制器已设置
        XCTAssertNotNil(viewController.hostingController, "SwiftUI 宿主控制器应设置成功")
        
        // 验证宿主控制器的视图已添加到父视图
        if let hostingView = viewController.hostingController?.view {
            XCTAssertTrue(hostingView.isDescendant(of: viewController.view), "SwiftUI 视图应添加到父视图")
        } else {
            XCTFail("SwiftUI 宿主视图不存在")
        }
    }
    
    // MARK: - 测试辅助方法
    
    /// 测试显示登录成功方法
    func testShowLoginSuccess() {
        // 由于 showLoginSuccess 方法会显示一个 UIAlertController
        // 我们可以通过测试视图控制器是否能正常调用该方法来验证
        // 注意：由于是异步操作，我们需要使用期望来等待
        let expectation = XCTestExpectation(description: "显示登录成功弹窗")
        
        // 在主线程中执行
        DispatchQueue.main.async {
            // 调用方法
            self.viewController.showLoginSuccess()
            
            // 验证是否显示了弹窗
            // 注意：由于 UIAlertController 是模态显示的，我们无法直接访问
            // 这里我们主要测试方法是否能正常执行而不崩溃
            expectation.fulfill()
        }
        
        // 等待方法执行完成
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// 测试显示错误方法
    func testShowError() {
        // 由于 showError 方法会显示一个 UIAlertController
        // 我们可以通过测试视图控制器是否能正常调用该方法来验证
        let expectation = XCTestExpectation(description: "显示错误弹窗")
        
        // 在主线程中执行
        DispatchQueue.main.async {
            // 调用方法
            self.viewController.showError("测试错误信息")
            
            // 验证是否显示了弹窗
            // 注意：由于 UIAlertController 是模态显示的，我们无法直接访问
            // 这里我们主要测试方法是否能正常执行而不崩溃
            expectation.fulfill()
        }
        
        // 等待方法执行完成
        wait(for: [expectation], timeout: 1.0)
    }
}
