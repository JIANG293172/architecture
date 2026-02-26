import Foundation

/**
 1. Actor Demo
 
 Interview Question: What is an Actor in Swift?
 
 Answer: 
 Actors are a reference type (like classes) that protect their state from data races. 
 They ensure that only one task can access their mutable state at a time by using 
 "actor isolation". All access to an actor's properties or methods from outside must 
 be done asynchronously using 'await'.
 */

actor BankAccount {
    private var balance: Double = 0
    
    init(initialBalance: Double) {
        self.balance = initialBalance
    }
    
    func deposit(amount: Double) {
        balance += amount
        print("Deposited: \(amount), New Balance: \(balance)")
    }
    
    func withdraw(amount: Double) throws -> Double {
        guard balance >= amount else {
            throw NSError(domain: "Insufficient funds", code: 0)
        }
        balance -= amount
        print("Withdrew: \(amount), Remaining Balance: \(balance)")
        return amount
    }
    
    // External access to this property must be awaited
    func getBalance() -> Double {
        return balance
    }
}

class ActorDemo {
    func runDemo() {
        let account = BankAccount(initialBalance: 100)
        
        Task {
            // Accessing actor methods requires 'await'
            await account.deposit(amount: 50)
            
            do {
                let withdrawn = try await account.withdraw(amount: 30)
                print("Successfully withdrawn: \(withdrawn)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
            let finalBalance = await account.getBalance()
            print("Final Balance in Actor: \(finalBalance)")
        }
    }
}
