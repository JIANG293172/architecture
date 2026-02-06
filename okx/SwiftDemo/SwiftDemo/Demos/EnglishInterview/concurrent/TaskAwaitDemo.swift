import Foundation

/**
 2. Task and Await Demo
 
 Interview Question: How do Task and await work in Swift?
 
 Answer: 
 'async' marks a function as asynchronous, meaning it can suspend its execution. 
 'await' marks a suspension point where the code waits for the async function to finish 
 without blocking the current thread. 
 'Task' creates a new unit of asynchronous work, allowing you to run async code from 
 synchronous contexts (like UIKit lifecycle methods).
 */

class TaskAwaitDemo {
    
    // An async function that simulates fetching data
    func fetchData() async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second
        return "Data from Server"
    }
    
    func processData() async {
        print("Starting process...")
        
        do {
            // Sequential execution: waits for fetchData to complete
            let result = try await fetchData()
            print("Received: \(result)")
            
            // Parallel execution using 'async let'
            print("Fetching multiple items in parallel...")
            async let item1 = fetchData()
            async let item2 = fetchData()
            
            let results = try await [item1, item2]
            print("Parallel results: \(results)")
            
        } catch {
            print("Error occurred: \(error)")
        }
    }
    
    func runDemo() {
        // Creating a Task to bridge sync and async
        Task {
            await processData()
            print("Demo finished")
        }
    }
}
