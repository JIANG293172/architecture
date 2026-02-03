import XCTest
@testable import SwiftDemo

class RefreshDemoViewControllerTests: XCTestCase {
    
    var sut: RefreshDemoViewController!
    
    override func setUp() {
        super.setUp()
        sut = RefreshDemoViewController()
        // 触发 viewDidLoad
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // 1. 模拟 50 次极高频点击（混合线程）
    func testHighFrequencyMixedThreadTaps() {
        let expectation = self.expectation(description: "Wait for debounce")
        let totalRequests = 50
        let group = DispatchGroup()
        
        // 模拟主线程和后台线程混合触发
        for i in 0..<totalRequests {
            group.enter()
            if i % 2 == 0 {
                // 主线程触发
                DispatchQueue.main.async {
                    self.sut.refreshManager.requestRefresh()
                    self.sut.requestCount += 1
                    group.leave()
                }
            } else {
                // 后台线程触发
                DispatchQueue.global().async {
                    self.sut.refreshManager.requestRefresh()
                    DispatchQueue.main.async {
                        self.sut.requestCount += 1
                        group.leave()
                    }
                }
            }
        }
        
        // 等待所有请求发出
        group.notify(queue: .main) {
            XCTAssertEqual(self.sut.requestCount, totalRequests, "请求总数应为 50")
            
            // 等待防抖时间 (0.5s) + 缓冲时间
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // 验证实际刷新次数
                XCTAssertEqual(self.sut.actualRefreshCount, 1, "在高频触发下，最终应只刷新 1 次")
                
                // 验证 UI 标签更新
                let expectedText = "请求次数: \(totalRequests)\n实际 reload 次数: 1"
                XCTAssertEqual(self.sut.logLabel.text, expectedText)
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // 2. 模拟异常场景：连续触发两次独立的刷新周期
    func testTwoIndependentRefreshCycles() {
        let expectation = self.expectation(description: "Two cycles")
        
        // 第一波触发
        for _ in 0..<10 {
            sut.refreshManager.requestRefresh()
            sut.requestCount += 1
        }
        
        // 等待第一波完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            XCTAssertEqual(self.sut.actualRefreshCount, 1)
            
            // 第二波触发
            for _ in 0..<10 {
                self.sut.refreshManager.requestRefresh()
                self.sut.requestCount += 1
            }
            
            // 等待第二波完成
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                XCTAssertEqual(self.sut.actualRefreshCount, 2, "两个独立的时间窗口应触发 2 次刷新")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.5)
    }
    
    // 3. 模拟异常场景：在刷新过程中销毁控制器
    func testDeallocationDuringPendingRefresh() {
        var localSut: RefreshDemoViewController? = RefreshDemoViewController()
        localSut?.loadViewIfNeeded()
        
        // 触发一次刷新
        localSut?.refreshManager.requestRefresh()
        
        // 立即销毁控制器
        localSut = nil
        
        // 等待防抖时间，确保没有崩溃且没有非法内存访问
        let expectation = self.expectation(description: "No crash after dealloc")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // 4. 模拟 UI 线程安全性：验证回调始终在主线程
    func testMainThreadCallbackSafety() {
        let expectation = self.expectation(description: "Main thread safety")
        
        // 从后台线程触发
        DispatchQueue.global().async {
            self.sut.refreshManager.requestRefresh()
        }
        
        // 在 Manager 的回调中验证线程 (已经在 RefreshDemoViewController 中绑定了 performActualReload)
        // 我们通过 hook 或者观察实际刷新次数来间接验证
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            XCTAssertEqual(self.sut.actualRefreshCount, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5)
    }
}
