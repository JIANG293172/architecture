import Foundation

/**
 NSOperation & NSOperationQueue
 
 1. Dependency: Link operations together (A must finish before B starts).
 2. MaxConcurrentOperationCount: Control the concurrency level easily.
 3. Cancellation: Operations can be cancelled even while running (if handled).
 4. KVO/State: Monitor state like isReady, isExecuting, isFinished.
 
 Comparison & Principle:
 - Performance: Slightly lower than GCD because it's an Objective-C wrapper around GCD.
 - Practicality: Best for complex task graphs, dependencies, and reusable operation logic.
 - Principle: An abstraction over GCD. It treats tasks as objects (Operations), providing more control over lifecycle.
 */

class NSOperationDemo {
    
    // MARK: - 1. Dependencies & Grouping
    func runDependencyDemo() {
        print("--- NSOperation Dependency Demo ---")
        let queue = OperationQueue()
        
        let op1 = BlockOperation {
            print("Operation 1 (Download Data) starting...")
            Thread.sleep(forTimeInterval: 1.5)
            print("Operation 1 finished.")
        }
        
        let op2 = BlockOperation {
            print("Operation 2 (Process Data) starting...")
            Thread.sleep(forTimeInterval: 1)
            print("Operation 2 finished.")
        }
        
        let op3 = BlockOperation {
            print("Operation 3 (Update UI) starting...")
            print("Operation 3 finished.")
        }
        
        // Setting dependencies
        op2.addDependency(op1) // op2 waits for op1
        op3.addDependency(op2) // op3 waits for op2
        
        queue.addOperations([op1, op2, op3], waitUntilFinished: false)
    }
    
    // MARK: - 2. MaxConcurrentOperationCount
    func runConcurrencyLimitDemo() {
        print("--- NSOperation Concurrency Limit Demo ---")
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2 // Only 2 operations run at once
        
        for i in 1...5 {
            queue.addOperation {
                print("Operation \(i) started on thread: \(Thread.current)")
                Thread.sleep(forTimeInterval: 2)
                print("Operation \(i) finished.")
            }
        }
    }
    
    // MARK: - 3. Custom Operation (Advanced)
    class CustomDownloadOperation: Operation {
        let url: String
        init(url: String) { self.url = url }
        
        override func main() {
            if isCancelled { return }
            print("Custom Op: Downloading from \(url)...")
            Thread.sleep(forTimeInterval: 2)
            if isCancelled {
                print("Custom Op: Cancelled after download.")
                return
            }
            print("Custom Op: Download finished.")
        }
    }
    
    func runCustomOperationDemo() {
        print("--- Custom NSOperation Demo ---")
        let queue = OperationQueue()
        let op = CustomDownloadOperation(url: "https://example.com/file")
        queue.addOperation(op)
        
        // Cancel it after 1 second to show cancellation logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Attempting to cancel custom operation...")
            op.cancel()
        }
    }
    
    func runDemo() {
        runDependencyDemo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.runConcurrencyLimitDemo()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.runCustomOperationDemo()
        }
    }
}
