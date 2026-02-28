import Foundation

/**
 Swift Language Interview Examples
 This class contains 50 typical Swift usage examples focusing on:
 1. Higher-Order Functions (map, filter, reduce, etc.)
 2. Basics & Optionals
 3. Collections & Memory Management
 4. Structs, Classes & Protocols
 5. Advanced Swift Features
 */

// MARK: - Helper Declarations (File Scope)

protocol Greetable { func greet() }
extension Greetable { func greet() { print("Hello!") } }
struct PersonGreetable: Greetable {}

extension Int { var squaredValue: Int { self * self } }

@propertyWrapper
struct Trimmed {
    private(set) var value: String = ""
    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespaces) }
    }
    init(wrappedValue: String) { self.wrappedValue = wrappedValue }
}

infix operator **
func **(base: Double, power: Double) -> Double { pow(base, power) }

@dynamicMemberLookup
struct DynamicPerson {
    subscript(dynamicMember member: String) -> String { "Value for \(member)" }
}

// MARK: - Examples Model

struct SwiftExample {
    let title: String
    let explanation: String
    let action: () -> Void
}

class SwiftLanguageExamples {
    
    static let shared = SwiftLanguageExamples()
    
    func getAllExamples() -> [SwiftExample] {
        var examples: [SwiftExample] = []
        
        //        "In Swift, the map method is a higher-order function used on collections. Its core purpose is to transform each element into a new value, by applying a given closure to every element, and then return a new collection containing all these transformed values. Importantly, map does not modify the original collection—it always returns a new one, which makes it immutable and safe to use.
        examples.append(SwiftExample(title: "1. Map", explanation: "Transforms each element in a collection.") {
            let numbers = [1, 2, 3]
            let squared = numbers.map { $0 * $0 }
            print("Map: [1, 2, 3] -> \(squared)")
            
            /// 输入有可选类型的情况下，返回必须有一个确定的值
            let numberss2 = [-1, nil , -2, -3]
            let addNumbers = numberss2.map { number in
                guard let number = number else {
                    return 0
                }
                let returnValue = number > 0 ? number : -number
                return returnValue
            }
            print(addNumbers)

            let dictions = ["age1": 1, "age2": 2, "age3": 3]
            print(dictions)

            let changeDictionary = dictions.map { ($0 , String($1)) }
            print(changeDictionary)
        })
        
//     select and retain only the elements that satisfy a given condition (defined by a closure).
//        It works by iterating over every element in the original collection, evaluating the closure (which returns a Boolean true/false) for each element: if the closure returns true, the element is included in the new collection; if false, it is excluded. Importantly, filter is non-mutating—it never modifies the original collection, and always returns a new collection containing only the filtered elements.
        
        examples.append(SwiftExample(title: "2. Filter", explanation: "Selects elements that satisfy a condition.") {
            let numbers = [1, 2, 3, 4, 5, 6]
            let evens = numbers.filter { $0 % 2 == 0 }
            
            /// 输入为可选的情况下，返回必须要一个确定的值
            print("Filter Evens: \(evens)")
            let numbers2 = [1, 2, nil, 3, 4, 5, 6]
            let evens2 = numbers2.filter { num in
                guard let num = num else {
                    return false
                }
                return num % 2 == 0
            }
            
            print("Filter Evens: \(evens2)")
        })
        
        
//      combines all elements of the collection into a single value (called the 'accumulator' or 'result value') by applying a closure iteratively.
//        It takes two key parameters:
//        An initial value (the starting point of the accumulation);
//        A closure that takes two arguments (the current accumulated value, and the next element in the collection) and returns a new accumulated value.
        examples.append(SwiftExample(title: "3. Reduce", explanation: "Combines all elements into a single value.") {
            let numbers = [1, 2, 3, 4]
            let sum = numbers.reduce(0, +)
            
            print("Reduce Sum: \(sum)")

            /// 有可选类型，返回值需要有值
            let numbers2 = [1, 2, nil, 3, 4]
            let sum2 = numbers2.reduce(1) { partialResult, num in
                guard let num = num else {
                    return partialResult
                }
                return partialResult * num
            }
            print("Reduce Sum: \(sum2)")
        })
        
//        transforming elements (like map)
//        filtering out nil values (unlike map).
//        It works by iterating over each element in the original collection, applying a transformation closure to it (which can return an optional value), and then including only the non-nil results in the new collection. Importantly, compactMap removes all nil values from the transformed results, so the output collection only contains non-optional, valid values.
        examples.append(SwiftExample(title: "4. CompactMap", explanation: "Transforms elements and removes nil values.") {
            let strings = ["1", "two", "3", "four"]
            let numbers = strings.compactMap { Int($0) }
            print("CompactMap (valid ints): \(numbers)")
            
            /// 有可选类型，不能直接返回nil，会导致编译器无法识别类型报错
            let strings2 = ["1", "two", nil, "3", "four"]
            let numbers2 = strings2.compactMap { num in
                guard let num = num  else {
                    return (nil as Int?)
                }
                return Int(num)
            }
            print("CompactMap (valid ints): \(numbers2)")
        })
        
        //        For nested collections (e.g., [[1,2], [3,4]]): It 'flattens' the nested structure into a single-level collection (e.g., [1,2,3,4]), while applying a transformation closure to each element.
        //        For collections of optional values (e.g., [String?]): It combines unwrapping optionals and filtering out nil values (similar to compactMap for optional elements), then applies a transformation.
        examples.append(SwiftExample(title: "5. FlatMap", explanation: "Flattens nested collections or unwraps nested optionals.") {
            let nested = [[1, 2], [3, 4], [5]]
            let flattened = nested.flatMap {$0}
            print("FlatMap (flattened): \(flattened)")
            
            //  含有
            let nested2 = [[1, 2], [22, nil], [3, 4], [5]]
            let flattened2 = nested2.flatMap { num in
                let filteredInnerArray = num.compactMap { $0 }
                return filteredInnerArray
            }
            print("FlatMap (flattened): \(flattened2)")
        })
        
//        executes a given closure once for each element in the collection—it’s a functional alternative to the traditional for-in loop.
//        Unlike map/filter/reduce, forEach does not return any value (its return type is Void). It simply iterates over every element and performs a side effect (e.g., printing, modifying a variable, updating UI) for each one.
        examples.append(SwiftExample(title: "6. ForEach", explanation: "Iterates over each element (cannot use break/continue).") {
            [1, 2, 3].forEach { print("ForEach: \($0)") }
        })
        
        examples.append(SwiftExample(title: "7. Sorted", explanation: "Returns a sorted version of the collection.") {
            let unsorted = [3, 1, 4, 1, 5]
            print("Sorted: \(unsorted.sorted())")
            
            
            let numbers = [3, 1, 4, 1, 5]
            let descending = numbers.sorted { $0 > $1 }
            print("Custom sorted (descending): \(descending)") // Output: [5, 4, 3, 1, 1]
            
            let numbers3 = [3, 1, 4, 1, 5]
            // > 表示降序，< 表示升序（运算符作为闭包传入）
            let descending2 = numbers3.sorted(by: >)
            print("Sorted with operator (descending): \(descending2)") // Output: [5, 4, 3, 1, 1]
        })
        

        
        /*
         "In Swift, partition(by:) is a mutating method for mutable collections (like var arrays) that rearranges elements in-place based on a Boolean predicate (a closure returning true/false).
         Its core purpose is to split the collection into two contiguous parts:
         All elements that do NOT satisfy the predicate (return false) come first;
         All elements that satisfy the predicate (return true) come after;
         The method returns an Int index—the position of the first element that satisfies the predicate (the boundary between the two parts). Importantly, partition(by:) modifies the original collection (it’s mutating) and does not guarantee sorting within each part.
        */
        examples.append(SwiftExample(title: "8. Partition", explanation: "Reorders elements based on a predicate.") {
            var numbers = [10, 5, 8, 2, 7]
            let pivot = numbers.partition(by: { $0 > 5 })
            print("Partitioned (split at index \(pivot)): \(numbers)")
        })
        
        
        /*
         "In Swift, a 'safe unwrapper' refers to language constructs that safely extract the underlying value from an optional type (denoted with ?) without triggering a runtime crash—unlike force unwrapping (using !), which crashes if the optional is nil.
         The most common safe unwrapper is the if let syntax (optional binding):
         It checks if the optional contains a non-nil value;
         If yes: it binds the value to a local constant (e.g., unwrapped) and executes the code block;
         If no (optional is nil): it skips the code block entirely.
        */
        let tempValue = 1
        var mutableValue = 2

        
        /*
         let declares a constant (immutable value) that cannot be reassigned after initialization.
         var declares a variable (mutable value) that can be modified. Use let by default for safety and performance, only use var when the value needs to change.
        */
        examples.append(SwiftExample(title: "9. Optional Binding (if let)", explanation: "Safely unwrap optionals.") {
            let name: String? = "Swift"
            if let unwrapped = name { print("Unwrapped: \(unwrapped)") }
        })
        
        
        /*
         "guard let name = name else { return } is a safe unwrapping pattern (optional binding) in Swift:
         It checks if the optional name has a non-nil value
         —if yes, it binds the unwrapped value to name (available in the outer scope);
         if nil, it exits the current scope (via return) immediately.
         Key benefits: Enforces early exit for invalid nil values, avoids nested code, and maintains Swift’s type safety (no runtime crashes from force unwrapping)."
         */
        examples.append(SwiftExample(title: "10. Guard Statement", explanation: "Early exit from a function if condition isn't met.") {
            func greet(_ name: String?) {
                guard let name = name else { return }
                print("Hello, \(name)")
            }
            greet("Developer")
        })
        
        /*
         "The ?? operator is Swift’s nil coalescing operator: it returns the unwrapped value of an optional if it’s non-nil,
         or a specified default value if the optional is nil.
         
         It’s a concise, safe way to handle optionals without force unwrapping.
         Example: let username = inputName ?? "Guest" → uses "Guest" as the default if inputName is nil."
         */
        examples.append(SwiftExample(title: "11. Nil Coalescing (??)", explanation: "Provide a default value for an optional.") {
            let name: String? = nil
            print("User: \(name ?? "Guest")")
        })
        
        /*
         "defer is a Swift statement that schedules a block of code to execute when the current scope exits (e.g., end of a function/loop/if block)—regardless of how the scope exits (normal completion, return, throw, or break).
         
         It’s commonly used for cleanup tasks like closing files, releasing resources, or resetting state, ensuring cleanup code runs reliably.
         Example: defer { file.close() } → guarantees the file is closed when the scope exits."
         */
        examples.append(SwiftExample(title: "12. Defer", explanation: "Code that runs just before the current scope exits.") {
            print("Step 1")
            defer { print("Step 3 (Deferred)") }
            print("Step 2")
        })
        
        /*
         "lazy is a Swift property modifier that delays the initialization of a variable until it’s accessed for the first time (not when the containing type is initialized). It’s used for expensive/resource-heavy values (e.g., large data loading, complex computations) to optimize performance—avoids unnecessary initialization if the property is never used.
         Example: lazy var slowLoad = { ... }() → the closure runs only when slowLoad is first accessed, printing 'Slow loading...' once."
         */
        examples.append(SwiftExample(title: "13. Lazy Property", explanation: "Calculated only when first accessed.") {
            class LazyDemo {
                lazy var slowLoad: String = {
                    print("Slow loading...")
                    return "Done"
                }()
            }
            let demo = LazyDemo()
            print("Before access")
            print(demo.slowLoad)
        })
        
        // --- 3. Structs & Classes ---
        /*
         Inheritance: Structs do not support inheritance (only conform to protocols), while Classes support single inheritance and method overriding.
         Type nature: Structs are value types (copy entire data on assignment/pass), Classes are reference types (copy only memory address).
         Memory management: Structs have no reference counting (stack-allocated, lightweight) and no ARC overhead; Classes use ARC (heap-allocated) with reference counting (risk of retain cycles).
         Initialization: Structs get an automatic memberwise initializer; Classes require manual initializers (no default).
         Mutability & Identity: Structs are immutable by default (modify only with var), no unique identity (compare with ==); Classes allow modifying mutable properties even for let instances, and have unique identity (compare with ===).
         Destruction: Structs have no deinit (auto-released with scope); Classes have deinit for custom cleanup logic.
         */
        examples.append(SwiftExample(title: "14. Struct (Value Type)", explanation: "Passed by copying.") {
            struct Point { var x: Int }
            var p1 = Point(x: 10)
            var p2 = p1
            p2.x = 20
            print("Struct: p1.x=\(p1.x), p2.x=\(p2.x)")
        })
        
        
        /*
         结构体 外部可以通过var修改变量，内部的函数不要mutating修饰来修改
         
         栈上： 修改后，结构体会销毁，在原来的位置重新创建
         "Your understanding has a key correction: Structs (value types) do NOT use pointers (a reference type/class feature)—var structValue is stored directly in stack memory (not a pointer to heap memory).
         When you modify a var property (e.g., structValue.name = ""):
         The original struct data in the same stack memory address is destroyed;
         A new modified struct instance is created at the same stack address (not a new address);
         A new stack address is only created if the struct is assigned to another variable (e.g., let copy = structValue), triggering a full copy.
         Example:
         
         堆上
         
         "When a struct is a property of a class (reference type), the struct’s data is stored on the heap (as part of the class instance), but modifying the struct’s var properties still follows value type semantics:
         The class instance (including the struct property) lives at a fixed heap address (the class’s pointer never changes for modification);
         When you modify the struct’s property (e.g., classInstance.structProperty.name = ""), the original struct data in the class’s heap memory is destroyed, and a new modified struct instance is created in the same heap location (not a new heap address);
         No new heap address is created—only the struct data within the class’s heap space is replaced (value type copy behavior, but on the heap instead of the stack).
         Example:
         
         */
        
        examples.append(SwiftExample(title: "15. Class (Reference Type)", explanation: "Passed by reference.") {
            class Box { var value: Int = 0 }
            let b1 = Box()
            let b2 = b1
            b2.value = 100
            print("Class: b1.value=\(b1.value), b2.value=\(b2.value)")
        })
        
        examples.append(SwiftExample(title: "16. Mutating Functions", explanation: "Allow modifying properties in a struct.") {
            struct Counter {
                var count = 0
                mutating func increment() { count += 1 }
            }
            var c = Counter()
            c.increment()
            print("Count: \(c.count)")
        })
        
        /*
         
         "Protocols in Swift are a behavioral contract defining requirements (methods/properties) for types to conform to, core to OOP and Swift’s Protocol-Oriented Programming (POP):
         Multiple conformance: A single type (struct/class/enum) can conform to multiple protocols, enabling flexible behavior composition (solves single inheritance limits of classes, a key OOP advantage).
         Default implementations: Protocol extensions provide default behavior for requirements—conforming types inherit it or override as needed (boosts code reuse).
         No stored properties: Protocols only declare property requirements (with get/get set), not stored properties (they define what a type has, not how to store it).
         Key additions:
         Associated types: Make protocols generic (supports type-safe abstraction for reusable components like Collection).
         Protocol as type: Enables polymorphism (treat different conforming types uniformly as the protocol type).
         Protocol inheritance: Protocols inherit from other protocols (aggregate requirements, no implementation).
         Optional requirements: @objc protocols support optional requirements (for Objective-C interoperability, class-only conformance).
         Protocols drive abstraction, polymorphism and code reuse — Swift’s preferred alternative to rigid class inheritance."
         
         */
        
        /*
         协议实现继承
         "Yes, protocols in Swift do support inheritance—this is a key feature of Swift’s protocol system, but it differs fundamentally from class inheritance:
         Protocol inheritance allows a child protocol to inherit requirements (methods, properties) from one or more parent protocols (supporting multiple inheritance), which only aggregates all requirements into the child protocol (no implementation is inherited).
         A type conforming to the child protocol must implement all requirements from both the child and parent protocols combined.
         Critical limitation: Protocols can only inherit from other protocols—they cannot inherit from concrete types like classes, structs, or enums (concrete types conform to protocols instead)."
         
         */
        
        // --- 4. Protocols & Generics ---
        examples.append(SwiftExample(title: "17. Protocol Extensions", explanation: "Provide default implementations for protocols.") {
            PersonGreetable().greet()
        })
        
        /*
         编译期延迟决议（直到协议被遵循时）
         // 1. 定义带关联类型的协议（泛型协议）
         protocol RequestProtocol {
             // 关联类型 = 协议的泛型占位符，抽象声明“返回数据类型”
             associatedtype ResponseType // 决议时机：延迟到遵循协议时
             
             // 协议方法：使用关联类型
             func execute() -> ResponseType?
         }

         // 2. 遵循协议时，决议关联类型（编译期确定具体类型）
         // 场景1：用户列表请求（ResponseType = [User]）
         struct UserListRequest: RequestProtocol {
             // 决议：将抽象的 ResponseType 绑定为具体类型 [User]
             typealias ResponseType = [User]
             
             func execute() -> [User]? {
                 return [User(name: "张三"), User(name: "李四")]
             }
         }
         
         
         
         编译期静态决议（扩展定义时确定约束）
         // 基于上面的 RequestProtocol 扩展
         extension RequestProtocol {
             // 扩展泛型约束：仅当 ResponseType 是 [Decodable] 数组时，生效此方法
             func parseArrayData<T: Decodable>(_ data: Data) -> [T]? where ResponseType == [T] {
                 return try? JSONDecoder().decode([T].self, from: data)
             }
         }

         // 使用：UserListRequest 的 ResponseType = [User]（符合 [Decodable]），可调用扩展方法
         let userRequest = UserListRequest()
         let data = Data()
         let users = userRequest.parseArrayData(data) // 编译期决议 T = User，静态确定
         
         
         Both lazy resolution (for protocol associated types) and static resolution (for protocol extension generics) happen at compile time (no runtime overhead—this is a key advantage of Swift generics). The critical difference is when and how the compiler binds concrete types to generic placeholders during compilation:
         1. Compile-time Lazy Resolution (for associatedtype in protocols)
         Definition: Lazy resolution means the compiler defers binding concrete types to associatedtype (protocol generics) until a type conforms to the protocol (not when the protocol itself is defined).
         Why "lazy": When you define a protocol with associatedtype, the compiler only records the "abstract placeholder" (e.g., ResponseType), but has no idea what concrete type it will be. It waits until it encounters a conforming type (e.g., a struct/class that adopts the protocol) to resolve the associatedtype to a specific type (e.g., [User] or Product).
         
         // Protocol definition (only abstract placeholder, no resolution yet)
         protocol RequestProtocol {
             associatedtype ResponseType // Lazy resolution: no concrete type bound here
             func execute() -> ResponseType?
         }

         // Conforming type (resolution happens HERE at compile time)
         struct UserRequest: RequestProtocol {
             // Compiler resolves ResponseType = [User] ONLY when processing this conforming type
             func execute() -> [User]? { return [User()] }
         }
         
         
         Compile-time Static Resolution (for protocol extension generics)
         Definition: Static resolution means the compiler locks in generic constraints when the protocol extension is defined (not when it’s called). When you invoke an extension method, the compiler immediately checks if the conforming type meets the pre-defined constraints (no deferral).
         Why "static": The extension’s generic rules (e.g., where ResponseType: Decodable) are fixed at extension definition time. At call time, the compiler only validates if the conforming type matches these rules—resolution happens instantly (no waiting).

         // Extension definition (static constraints locked in HERE)
         extension RequestProtocol where ResponseType: Decodable {
             func decode() -> ResponseType? { /* ... */ }
         }

         // Call time (static resolution: immediate matching)
         let userReq = UserRequest()
         userReq.decode() // Compiler instantly checks: [User] conforms to Decodable → resolution succeeds
         
         
         
         */
        examples.append(SwiftExample(title: "18. Generics", explanation: "Write code that works with any type.") {
            func swapValues<T>(_ a: inout T, _ b: inout T) {
                let temp = a; a = b; b = temp
            }
            var x = 1, y = 2
            swapValues(&x, &y)
            print("Swapped: x=\(x), y=\(y)")
        })
        
        examples.append(SwiftExample(title: "19. Associated Types", explanation: "Placeholders in protocols for generics.") {
            protocol Container {
                associatedtype Item
                var items: [Item] { get }
            }
            struct IntContainer: Container {
                var items: [Int] = [1, 2, 3]
            }
            print("Container items: \(IntContainer().items)")
        })
        
        // --- 5. Memory Management ---
        examples.append(SwiftExample(title: "20. Weak Reference", explanation: "Prevents retain cycles, always optional.") {
            print("Weak avoids strong reference cycles.")
        })
        
        examples.append(SwiftExample(title: "21. Unowned Reference", explanation: "Prevents retain cycles, assumes object exists.") {
            print("Unowned used when lifetime of one object depends on another.")
        })
        
        examples.append(SwiftExample(title: "22. Closure Capture List", explanation: "Define how variables are captured.") {
            var x = 0
            let closure = { [x] in print("Captured x: \(x)") }
            x = 10
            closure() // Still prints 0 because it was captured as a value
        })
        
        // --- 6. Advanced Collections ---
        examples.append(SwiftExample(title: "23. Dictionary Grouping", explanation: "Group array elements into a dictionary.") {
            let names = ["Alice", "Bob", "Charlie", "Anna"]
            let grouped = Dictionary(grouping: names, by: { $0.first! })
            print("Grouped by first letter: \(grouped)")
        })
        
        examples.append(SwiftExample(title: "24. Set Operations", explanation: "Intersection, union, etc.") {
            let s1: Set = [1, 2, 3]
            let s2: Set = [3, 4, 5]
            print("Union: \(s1.union(s2))")
            print("Intersection: \(s1.intersection(s2))")
        })
        
        examples.append(SwiftExample(title: "25. Array Slicing", explanation: "Efficiently access a range of elements.") {
            let nums = [0, 1, 2, 3, 4, 5]
            let slice = nums[1...3]
            print("Slice [1...3]: \(Array(slice))")
        })
        
        // --- 7. Property Wrappers & Observers ---
        examples.append(SwiftExample(title: "26. willSet / didSet", explanation: "Property observers.") {
            class Score {
                var value: Int = 0 {
                    didSet { print("Score changed to \(value)") }
                }
            }
            let s = Score(); s.value = 10
        })
        
        examples.append(SwiftExample(title: "27. Property Wrappers", explanation: "Custom logic for property access.") {
            struct Post { @Trimmed var title: String }
            var p = Post(title: "  Hello World  ")
            print("Trimmed title: '\(p.title)'")
        })
        
        // --- 8. Error Handling ---
        examples.append(SwiftExample(title: "28. do-catch / try?", explanation: "Handling errors.") {
            enum MyError: Error { case test }
            func fail() throws { throw MyError.test }
            let result = try? fail()
            print("Result with try?: \(String(describing: result))")
        })
        
        examples.append(SwiftExample(title: "29. Result Type", explanation: "Value representing success or failure.") {
            let success: Result<Int, Error> = .success(42)
            print("Result: \(success)")
        })
        
        // --- 9. Advanced Logic ---
        examples.append(SwiftExample(title: "30. KeyPaths", explanation: "Dynamic reference to properties.") {
            struct User { let name: String }
            let user = User(name: "John")
            print("Name via KeyPath: \(user[keyPath: \User.name])")
        })
        
        examples.append(SwiftExample(title: "31. Tuple Pattern Matching", explanation: "Switching on tuples.") {
            let coord = (1, 1)
            switch coord {
            case (0, 0): print("Origin")
            case (_, 0): print("On X axis")
            case (0, _): print("On Y axis")
            default: print("Elsewhere")
            }
        })
        
        examples.append(SwiftExample(title: "32. In-out Parameters", explanation: "Modify arguments passed to a function.") {
            func doubleIt(_ x: inout Int) { x *= 2 }
            var val = 5
            doubleIt(&val)
            print("Doubled: \(val)")
        })
        
        examples.append(SwiftExample(title: "33. Computed Properties", explanation: "Properties that calculate a value.") {
            struct Rect {
                var width: Double, height: Double
                var area: Double { width * height }
            }
            print("Area: \(Rect(width: 5, height: 10).area)")
        })
        
        examples.append(SwiftExample(title: "34. Final Keyword", explanation: "Prevent inheritance or overriding.") {
            print("final class prevents subclassing.")
        })
        
        examples.append(SwiftExample(title: "35. Extension", explanation: "Add functionality to existing types.") {
            print("5 squared: \(5.squaredValue)")
        })
        
        examples.append(SwiftExample(title: "36. Typealias", explanation: "Give a new name to an existing type.") {
            typealias Kilometers = Int
            let distance: Kilometers = 100
            print("Distance: \(distance) km")
        })
        
        examples.append(SwiftExample(title: "37. Any vs AnyObject", explanation: "Any for all types, AnyObject for class types.") {
            print("Any can hold value or reference types. AnyObject is for classes only.")
        })
        
        examples.append(SwiftExample(title: "38. Self vs self", explanation: "Self for types, self for instances.") {
            print("self refers to the current instance. Self refers to the current type.")
        })
        
        examples.append(SwiftExample(title: "39. Enum with Raw Values", explanation: "Predefined values for enums.") {
            enum Planet: Int { case mercury = 1, venus, earth }
            print("Earth raw value: \(Planet.earth.rawValue)")
        })
        
        examples.append(SwiftExample(title: "40. Enum with Associated Values", explanation: "Store extra info with enum cases.") {
            enum Barcode { case upc(Int, Int), qr(String) }
            let code = Barcode.qr("ABCDEFG")
            if case let .qr(s) = code { print("QR: \(s)") }
        })
        
        examples.append(SwiftExample(title: "41. CaseIterable", explanation: "Loop through all enum cases.") {
            enum Direction: CaseIterable { case north, south, east, west }
            print("All cases: \(Direction.allCases.count)")
        })
        
        examples.append(SwiftExample(title: "42. Static vs Class members", explanation: "Static prevents overriding, class allows it.") {
            print("Static: Cannot be overridden in subclasses. Class: Can be.")
        })
        
        examples.append(SwiftExample(title: "43. Escaping Closures", explanation: "Closure that outlives the function.") {
            print("@escaping is needed if closure is stored or used later.")
        })
        
        examples.append(SwiftExample(title: "44. Autoclosures", explanation: "Automatically wraps an expression in a closure.") {
            func logIfTrue(_ condition: @autoclosure () -> Bool) {
                if condition() { print("True!") }
            }
            logIfTrue(2 > 1)
        })
        
        examples.append(SwiftExample(title: "45. Opaque Types (some)", explanation: "Hide concrete return type but keep identity.") {
            print("Opaque types (some) allow returning a specific type without exposing its concrete identity.")
        })
        
        examples.append(SwiftExample(title: "46. Dynamic Member Lookup", explanation: "Access properties dynamically at runtime.") {
            let p = DynamicPerson()
            print(p.anything)
        })
        
        examples.append(SwiftExample(title: "47. Mirror (Introspection)", explanation: "Examine instance properties at runtime.") {
            struct User { let id: Int; let name: String }
            let u = User(id: 1, name: "Alice")
            let mirror = Mirror(reflecting: u)
            for child in mirror.children { print("\(child.label!): \(child.value)") }
        })
        
        examples.append(SwiftExample(title: "48. Range vs ClosedRange", explanation: "0..<5 vs 0...5.") {
            print("Range (..<): Excludes end. ClosedRange (...): Includes end.")
        })
        
        examples.append(SwiftExample(title: "49. Variadic Parameters", explanation: "Accept zero or more values of a type.") {
            func sum(_ numbers: Int...) -> Int { numbers.reduce(0, +) }
            print("Sum 1,2,3: \(sum(1, 2, 3))")
        })
        
        examples.append(SwiftExample(title: "50. Custom Operators", explanation: "Define your own symbols.") {
            print("2 ** 3 = \(2.0 ** 3.0)")
        })
        
        return examples
    }
}
