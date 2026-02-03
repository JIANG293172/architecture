import XCTest
import Combine
@testable import SwiftDemo

class CombineRefreshManagerTests: XCTestCase {
    
    var manager: CombineRefreshManager!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    // 1. 基础防抖测试：密集触发，只应执行 1 次
    func testDebounceLogic() {
        let expectation = self.expectation(description: "Debounce works")
        var callCount = 0
        
        manager = CombineRefreshManager(interval: 0.1)
        manager.bindRefreshAction {
            callCount += 1
        }
        
        // 密集触发
        for _ in 0..<50 {
            manager.requestRefresh()
        }
        
        // 延迟检查结果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if callCount == 1 {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // 2. 线程安全测试：多线程并发触发
    func testThreadSafety() {
        let expectation = self.expectation(description: "Thread Safety Concurrent")
        var callCount = 0
        
        manager = CombineRefreshManager(interval: 0.2)
        manager.bindRefreshAction {
            XCTAssertTrue(Thread.isMainThread)
            callCount += 1
        }
        
        let threads = 50
        let requestsPerThread = 100
        let group = DispatchGroup()
        
        for _ in 0..<threads {
            group.enter()
            DispatchQueue.global().async {
                for _ in 0..<requestsPerThread {
                    self.manager.requestRefresh()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // 所有请求发送完毕，等待防抖生效
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                XCTAssertEqual(callCount, 1, "并发环境下最终应只刷新一次")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // 3. 极端测试：极短时间间隔
    func testTinyInterval() {
        let expectation = self.expectation(description: "Tiny interval")
        var callCount = 0
        
        // 1ms 的极短间隔
        manager = CombineRefreshManager(interval: 0.001)
        manager.bindRefreshAction {
            callCount += 1
        }
        
        manager.requestRefresh()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertGreaterThanOrEqual(callCount, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5)
    }
    
    // 4. 极端测试：Manager 销毁后的行为
    func testDeallocationBehavior() {
        var callCount = 0
        let expectation = self.expectation(description: "Deallocation")
        
        var localManager: CombineRefreshManager? = CombineRefreshManager(interval: 0.1)
        localManager?.bindRefreshAction {
            callCount += 1
        }
        
        localManager?.requestRefresh()
        
        // 立即销毁 Manager
        localManager = nil
        
        // 等待足够时间，验证回调没有被触发
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(callCount, 0, "Manager 销毁后不应触发 pending 的刷新")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }

    // 5. 极端测试：重新绑定 Action
    func testRebindingAction() {
        let expectation = self.expectation(description: "Rebinding")
        var firstActionCalled = false
        var secondActionCalled = false
        
        manager = CombineRefreshManager(interval: 0.2)
        
        manager.bindRefreshAction {
            firstActionCalled = true
        }
        
        manager.requestRefresh()
        
        // 在防抖期间内，重新绑定 Action
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.manager.bindRefreshAction {
                secondActionCalled = true
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(firstActionCalled, "旧的 Action 不应被调用")
        XCTAssertTrue(secondActionCalled, "新的 Action 应该被调用")
    }
}
