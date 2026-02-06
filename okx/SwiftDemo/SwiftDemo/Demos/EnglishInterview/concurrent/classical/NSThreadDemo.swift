import Foundation

/**
 NSThread (Manual Thread Management)
 
 1. Basic Usage: Create and start a thread manually.
 2. Synchronization: Using NSLock to prevent data races.
 3. Thread Communication: performSelector(onMainThread:...)
 
 Comparison & Principle:
 - Performance: Lowest. Managing threads manually is expensive and error-prone.
 - Practicality: Rarely used in modern apps. Use GCD or Swift Concurrency instead.
 - Principle: A direct wrapper around pthreads (POSIX threads). You are responsible for the lifecycle and stack management.
 */

class NSThreadDemo {
    
    private var count = 0
    private let lock = NSLock()
    
    // MARK: - 1. Manual Thread Creation
    func runThreadDemo() {
        print("--- NSThread Basic Demo ---")
        
        let thread = Thread {
            print("NSThread running on: \(Thread.current)")
            self.doThreadWork()
        }
        thread.name = "MyCustomThread"
        thread.qualityOfService = .background
        thread.start()
    }
    
    func doThreadWork() {
        for _ in 1...3 {
            Thread.sleep(forTimeInterval: 1)
            print("Working on background thread...")
        }
        
        // Communication back to main thread (Classic way)
        // Note: performSelector is an ObjC method, in Swift we usually use DispatchQueue.main
        print("Thread work done, notifying main thread...")
        DispatchQueue.main.async {
            print("Notified Main Thread from NSThread.")
        }
    }
    
    // MARK: - 2. Thread Safety with NSLock
    func runLockDemo() {
        print("--- NSThread NSLock Demo ---")
        count = 0
        
        let t1 = Thread { self.incrementCount(threadID: 1) }
        let t2 = Thread { self.incrementCount(threadID: 2) }
        
        t1.start()
        t2.start()
    }
    
    func incrementCount(threadID: Int) {
        for _ in 1...5 {
            lock.lock() // Critical Section Start
            count += 1
            print("Thread \(threadID) incremented count to: \(count)")
            Thread.sleep(forTimeInterval: 0.1)
            lock.unlock() // Critical Section End
        }
    }
    
    func runDemo() {
        runThreadDemo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.runLockDemo()
        }
    }
}
