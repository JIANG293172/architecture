import Foundation
import Combine

/**
 GCD (Grand Central Dispatch) Advanced Usage
 
 1. GCD Timer: A timer based on dispatch sources, more accurate than Timer (NSTimer).
 2. GCD Group: Synchronize multiple asynchronous tasks.
 3. GCD Barrier: Solve the Reader-Writer problem by ensuring exclusive access.
 4. GCD Semaphore: Control the number of concurrent tasks.
 
 Comparison & Principle:
 - Performance: Very high. Written in C, it's a lightweight way to manage concurrent tasks.
 - Practicality: Extremely common for simple async tasks, data synchronization, and timing.
 - Principle: Based on thread pools and queues. It abstracts thread management away from the developer.
 */

class GCDDemo {
    
    // MARK: - 1. GCD Timer
    private var timer: DispatchSourceTimer?
    
    func startGCDTimer() {
        print("--- GCD Timer Started ---")
        // Use a background queue to avoid blocking main thread
        let queue = DispatchQueue.global()
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        // Schedule: start now, repeat every 1 second
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        
        var count = 0
        timer?.setEventHandler {
            count += 1
            print("GCD Timer tick: \(count)")
            if count >= 5 {
                self.stopGCDTimer()
            }
        }
        
        timer?.resume()
    }
    
    func stopGCDTimer() {
        print("--- GCD Timer Stopped ---")
        timer?.cancel()
        timer = nil
    }
    
    // MARK: - 2. GCD Barrier (Reader-Writer Problem)
    private let concurrentQueue = DispatchQueue(label: "com.demo.barrier", attributes: .concurrent)
    private var safeData: [String] = []
    
    func runBarrierDemo() {
        print("--- GCD Barrier Demo ---")
        
        // Multiple readers
        for i in 1...3 {
            concurrentQueue.async {
                print("Reader \(i) reading: \(self.safeData)")
            }
        }
        
        // Writer using barrier: ensures this block is the ONLY one running on the queue
        concurrentQueue.async(flags: .barrier) {
            print("Writer writing data...")
            self.safeData.append("New Data")
            Thread.sleep(forTimeInterval: 1) // Simulate work
            print("Writer finished.")
        }
        
        // More readers
        for i in 4...6 {
            concurrentQueue.async {
                print("Reader \(i) reading: \(self.safeData)")
            }
        }
    }
    
    // MARK: - 3. GCD Semaphore (Concurrency Limit)
    func runSemaphoreDemo() {
        print("--- GCD Semaphore Demo ---")
        let semaphore = DispatchSemaphore(value: 2) // Limit to 2 concurrent tasks
        let queue = DispatchQueue.global()
        
        for i in 1...5 {
            queue.async {
                semaphore.wait() // Request access
                print("Task \(i) started (Semaphore acquired)")
                Thread.sleep(forTimeInterval: 2) // Simulate work
                print("Task \(i) finished (Semaphore released)")
                semaphore.signal() // Release access
            }
        }
    }
    
    func runDemo() {
        startGCDTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.runBarrierDemo()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.runSemaphoreDemo()
        }
    }
}
