import Foundation
import UIKit

/**
 6. Modern Concurrency - @MainActor and AsyncStream
 
 Interview Question: What are @MainActor and AsyncStream?
 
 Answer: 
 - @MainActor is a global actor that ensures a class, property, or function always 
   runs on the main thread. It's essential for UI updates.
 - AsyncStream provides a way to create an asynchronous sequence that you can iterate 
   over using 'for await'. It's great for wrapping stream-like callbacks (e.g., 
   location updates or timers).
 */

// Example of @MainActor for UI safety
@MainActor
class UIUpdater {
    func updateLabel(_ label: UILabel, with text: String) {
        // This is guaranteed to run on the main thread
        label.text = text
        print("Label updated on main thread: \(Thread.isMainThread)")
    }
}

class ModernConcurrencyDemo {
    
    // MARK: - AsyncStream Example
    func countdownStream(from count: Int) -> AsyncStream<Int> {
        return AsyncStream { continuation in
            var currentCount = count
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                continuation.yield(currentCount)
                currentCount -= 1
                
                if currentCount < 0 {
                    timer.invalidate()
                    continuation.finish() // Close the stream
                }
            }
        }
    }
    
    func runAsyncStreamDemo() {
        Task {
            print("Starting AsyncStream countdown...")
            let stream = countdownStream(from: 5)
            
            for await value in stream {
                print("Stream value: \(value)")
            }
            print("Stream finished!")
        }
    }
    
    func runDemo() {
        runAsyncStreamDemo()
    }
}
