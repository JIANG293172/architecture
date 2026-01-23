import XCTest
import Combine
@testable import SwiftDemo

/// ThemeManager 测试用例
/// 测试主题管理器的功能
class ThemeManagerTests: XCTestCase {
    
    // MARK: - 测试对象
    private var themeManager: ThemeManager!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - 测试生命周期
    
    /// 每个测试方法执行前调用
    override func setUp() {
        super.setUp()
        // 创建测试对象
        themeManager = ThemeManager()
        cancellables = Set<AnyCancellable>()
    }
    
    /// 每个测试方法执行后调用
    override func tearDown() {
        // 清理测试对象
        themeManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - 测试主题管理
    
    /// 测试初始主题
    func testInitialTheme() {
        // 验证初始主题
        XCTAssertFalse(themeManager.isDarkMode, "初始主题应为浅色模式")
    }
    
    /// 测试主题切换
    func testToggleTheme() {
        // 初始状态
        XCTAssertFalse(themeManager.isDarkMode, "初始主题应为浅色模式")
        
        // 切换到深色模式
        themeManager.toggleTheme()
        XCTAssertTrue(themeManager.isDarkMode, "切换后主题应为深色模式")
        
        // 切换回浅色模式
        themeManager.toggleTheme()
        XCTAssertFalse(themeManager.isDarkMode, "再次切换后主题应为浅色模式")
    }
    
    /// 测试主题变化通知
    func testThemeChangeNotification() {
        // 设置期望，等待主题变化
        let expectation = XCTestExpectation(description: "主题变化")
        
        // 监听主题变化
        var receivedDarkModeValues: [Bool] = []
        
        // 使用 Combine 监听 @Published 属性
        themeManager.$isDarkMode
            .sink(receiveValue: { isDarkMode in
                print("收到主题变化: \(isDarkMode) ? \"深色模式\" : \"浅色模式\")")
                receivedDarkModeValues.append(isDarkMode)
            })
            .store(in: &cancellables)
        
        // 切换主题
        themeManager.toggleTheme()
        
        // 等待主题变化通知
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // 验证收到的主题值
            XCTAssertGreaterThan(receivedDarkModeValues.count, 0, "应至少收到一个主题值")
            
            // 验证最后一个主题值
            if let lastValue = receivedDarkModeValues.last {
                XCTAssertTrue(lastValue, "最后一个主题值应为 true (深色模式)")
            } else {
                XCTFail("未收到主题值")
            }
            
            // 完成期望
            expectation.fulfill()
        }
        
        // 等待主题变化完成
        wait(for: [expectation], timeout: 1.0)
    }
}
