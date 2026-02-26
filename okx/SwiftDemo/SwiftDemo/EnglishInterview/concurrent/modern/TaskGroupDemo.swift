import Foundation

/**
 4. Task Group Demo
 
 Interview Question: How does TaskGroup work? Do results return one by one?
 
 Answer: 
 TaskGroup allows you to manage dynamic numbers of child tasks. You add tasks to the 
 group using 'addTask'. 
 YES, results are yielded one by one as they finish when you iterate over the group 
 using 'for await result in group'. The order is NOT guaranteed; it depends on 
 which task finishes first.
 */

class TaskGroupDemo {
    
    func fetchPartialData(id: Int) async -> String {
        let delay = Double.random(in: 0.5...2.0)
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        return "Result \(id) (delayed \(String(format: "%.1f", delay))s)"
    }
    
    func runTaskGroup() async {
        print("Starting Task Group with dynamic child tasks...")
        
        await withTaskGroup(of: String.self) { group in
            // Add multiple child tasks
            for i in 1...5 {
                group.addTask {
                    return await self.fetchPartialData(id: i)
                }
            }
            
            // Collect results as they arrive
            // Note: Results will appear in the order they finish, not the order added.
            for await result in group {
                print("Task Group received: \(result)")
            }
        }
        
        print("Task Group finished all child tasks.")
    }
    
    func runDemo() {
        Task {
            await runTaskGroup()
        }
    }
}
