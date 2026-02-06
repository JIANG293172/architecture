import Foundation

/**
 5. GCD Group and NSOperation Group Demo
 
 Interview Question: How do you handle multiple tasks in GCD and NSOperation?
 
 Answer: 
 - In GCD, use 'DispatchGroup'. You enter the group before starting a task and leave 
   it after completion. Use 'group.notify' to be alerted when all tasks are done.
 - In NSOperation, use 'OperationQueue'. You can set dependencies between operations 
   using 'addDependency' to group and order them.
 */

class ClassicConcurrencyDemo {
    
    // MARK: - GCD DispatchGroup
    func runGCDGroupDemo() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        print("Starting GCD DispatchGroup...")
        
        for i in 1...3 {
            group.enter() // Enter before async work
            queue.asyncAfter(deadline: .now() + Double(i)) {
                print("GCD Task \(i) finished")
                group.leave() // Leave after async work finishes
            }
        }
        
        group.notify(queue: .main) {
            print("All GCD tasks in group finished!")
        }
    }
    
    // MARK: - NSOperation (OperationQueue)
    func runOperationQueueDemo() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        print("Starting OperationQueue Demo...")
        
        let op1 = BlockOperation {
            Thread.sleep(forTimeInterval: 1)
            print("Operation 1 finished")
        }
        
        let op2 = BlockOperation {
            Thread.sleep(forTimeInterval: 1)
            print("Operation 2 finished")
        }
        
        let finalOp = BlockOperation {
            print("Final Operation (Dependent on 1 and 2) finished")
        }
        
        // Grouping behavior via dependencies
        finalOp.addDependency(op1)
        finalOp.addDependency(op2)
        
        queue.addOperations([op1, op2, finalOp], waitUntilFinished: false)
    }
    
    func runDemo() {
        runGCDGroupDemo()
        // Wait a bit before starting next demo to avoid messy logs
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.runOperationQueueDemo()
        }
    }
}
