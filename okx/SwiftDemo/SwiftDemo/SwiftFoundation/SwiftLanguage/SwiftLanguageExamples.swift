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
         协议中的泛型使用：
         // 定义带关联类型的协议（泛型协议的等价实现）
         protocol Container {
             associatedtype Item  // 关联类型 = 协议的“泛型参数”
             var items: [Item] { get set }
             mutating func add(item: Item)
         }

         // 遵循协议时，决议 Item 的具体类型（编译时）
         struct IntContainer: Container {
             // 显式指定关联类型（编译时决议为 Int）
             typealias Item = Int
             var items: [Int] = []
             
             mutating func add(item: Int) {
                 items.append(item)
             }
         }

         // 隐式推导关联类型（编译时自动识别 Item 为 String）
         struct StringContainer: Container {
             var items: [String] = []  // 编译器通过 items 类型推导 Item = String
             mutating func add(item: String) {
                 items.append(item)
             }
         }
         
         
         协议扩展中使用泛型
         情况 1：扩展中使用协议的关联类型（最常见）
         扩展中直接使用协议定义的 associatedtype，类型决议时机和协议关联类型一致 ——编译时（协议被遵循时）。
         // 扩展 Container 协议，使用关联类型 Item
         extension Container {
             func firstItem() -> Item? {  // Item 已在遵循时决议
                 return items.first
             }
         }

         // 编译时已确定 firstItem() 返回 Int
         var intContainer = IntContainer()
         intContainer.add(item: 10)
         print(intContainer.firstItem())  // 输出 Optional(10)
         
         情况 2：扩展中自定义泛型参数
         协议扩展可以单独定义泛型参数（比如 extension Container where ... { func foo<T>(_: T) }），这类泛型的决议时机是：
         调用该方法 / 属性时编译决议（编译器根据传入的参数类型，在编译阶段确定泛型具体类型）。
         // 扩展中自定义泛型参数 T
         extension Container {
             func wrapItem<T>(with prefix: T) -> (T, Item) {
                 return (prefix, items.first!)
             }
         }

         // 调用时，T 被决议为 String（编译时）
         let wrapped = intContainer.wrapItem(with: "Number:")
         print(wrapped)  // 输出 ("Number:", 10)

         // 再次调用时，T 被决议为 Int（编译时）
         let wrapped2 = intContainer.wrapItem(with: 100)
         print(wrapped2)  // 输出 (100, 10)
         
         3. 特殊场景：协议作为 “存在类型”（Existential Type）
         Swift 5.7 引入 any 关键字，本质是创建一个存在类型容器，这个容器会在运行时包裹具体的遵循类型实例，从而解决 “类型不确定” 的问题。
         // 1. 定义带关联类型的协议
         protocol Container {
             associatedtype Item
             var items: [Item] { get }
             func firstItem() -> Item?
         }

         // 2. 两个遵循类型
         struct IntContainer: Container {
             typealias Item = Int
             var items: [Int] = [1,2,3]
             func firstItem() -> Int? { items.first }
         }

         struct StringContainer: Container {
             typealias Item = String
             var items: [String] = ["a","b"]
             func firstItem() -> String? { items.first }
         }

         // 3. 存在类型变量（Swift 5.7+）
         let container: any Container = IntContainer()
         // 👇 关键：调用 firstItem() 时的决议过程
         let item = container.firstItem()
         
         
         Any 类型的类型决议时机，他不是泛型，他是类型擦除。
         func addAnyType(type: Any) 中的 Any 是 Swift 的 “顶级类型”（所有类型都隐式遵循 Any），它的类型决议时机也是运行时，但机制和 any Protocol 完全不同：
         func addAnyType(type: Any) {
             // 编译时：编译器不知道 type 的具体类型，仅知道是 Any
             // 运行时：通过 is/as 关键字才能确定真实类型
             if let intValue = type as? Int {
                 print("Int 类型：\(intValue)")
             } else if let stringValue = type as? String {
                 print("String 类型：\(stringValue)")
             }
         }

         // 调用1：传入 Int
         addAnyType(type: 10)  // 运行时决议为 Int，输出 "Int 类型：10"
         // 调用2：传入 String
         addAnyType(type: "hello")  // 运行时决议为 String，输出 "String 类型：hello"
         
         
         
         any修饰符
         一、先理清关键前提：协议分两种
         Swift 中的协议可以分为两类，这是理解 any 作用的核心：
         普通协议（无 Self/ 关联类型约束）：比如 Codable、Equatable（非泛型版）、CustomStringConvertible 等；
         带关联类型的协议（PAT）：比如 Container（前面例子）、Sequence、Collection、IteratorProtocol 等。
         
         */
        
        
        /*
         1. Generics in Swift Protocols (Associated Types)
         In Swift, we cannot define protocols with generic parameters directly (e.g., protocol Container<T> is invalid). Instead, we use associated types to achieve "generic protocol" behavior, and type resolution happens at compile time when the protocol is conformed to.
         swift
         // Define a protocol with associated type (equivalent to generic protocol)
         protocol Container {
             associatedtype Item // Associated type = "generic parameter" for the protocol
             var items: [Item] { get set }
             mutating func add(item: Item)
         }

         // Explicit type resolution (Item = Int at compile time)
         struct IntContainer: Container {
             typealias Item = Int
             var items: [Int] = []
             
             mutating func add(item: Int) {
                 items.append(item)
             }
         }

         // Implicit type inference (compiler deduces Item = String at compile time)
         struct StringContainer: Container {
             var items: [String] = [] // Item inferred from items' type
             mutating func add(item: String) {
                 items.append(item)
             }
         }
         When a type conforms to Container, the compiler resolves the Item associated type statically at compile time (either explicitly via typealias or implicitly via context like property/method types).
         2. Generics in Protocol Extensions
         Protocol extensions support two common generic patterns, both resolved at compile time (no runtime overhead by default):
         Case 1: Using Associated Types in Extensions (Most Common)
         We directly use the protocol’s associated type in extensions—resolution timing matches the associated type (compile time, when the protocol is conformed to):
         swift
         extension Container {
             func firstItem() -> Item? { // Item already resolved at conformance time
                 return items.first
             }
         }

         // Usage: firstItem() returns Int? (resolved at compile time)
         var intContainer = IntContainer()
         intContainer.add(item: 10)
         print(intContainer.firstItem()) // Output: Optional(10)
         Case 2: Custom Generic Parameters in Extensions
         We can define standalone generic parameters in extensions. These are resolved at compile time when the method is called (compiler infers the generic type from the passed arguments):
         swift
         extension Container {
             func wrapItem<T>(with prefix: T) -> (T, Item) {
                 return (prefix, items.first!)
             }
         }

         // T resolved to String at compile time
         let wrapped = intContainer.wrapItem(with: "Number:")
         print(wrapped) // Output: ("Number:", 10)

         // T resolved to Int at compile time (reused method with different type)
         let wrapped2 = intContainer.wrapItem(with: 100)
         print(wrapped2) // Output: (100, 10)
         3. Special Case: Existential Types (any Keyword, Swift 5.7+)
         Swift 5.7 introduced the any keyword to enable existential types—a container that wraps concrete conforming instances at runtime, solving the "type uncertainty" issue for protocols with associated types (PATs).
         swift
         protocol Container {
             associatedtype Item
             var items: [Item] { get }
             func firstItem() -> Item?
         }

         struct IntContainer: Container {
             typealias Item = Int
             var items: [Int] = [1,2,3]
             func firstItem() -> Int? { items.first }
         }

         struct StringContainer: Container {
             typealias Item = String
             var items: [String] = ["a","b"]
             func firstItem() -> String? { items.first }
         }

         // Existential type variable (Swift 5.7+)
         let container: any Container = IntContainer()
         let item = container.firstItem() // Item resolved to Int at runtime
         The any keyword creates an existential container that stores: (1) the concrete instance (e.g., IntContainer), (2) type metadata (including associated type info).
         Type resolution for the associated type happens at runtime (compiler can’t know the concrete conforming type at compile time).
         4. Any Type (Type Erasure)
         Any is Swift’s top-level type (all types implicitly conform to Any), and its type resolution also happens at runtime—but it’s fundamentally different from any Protocol:
         swift
         func addAnyType(type: Any) {
             // Compile time: no concrete type info (only knows it’s Any)
             // Runtime: resolve type via `is/as` keywords
             if let intValue = type as? Int {
                 print("Int type: \(intValue)")
             } else if let stringValue = type as? String {
                 print("String type: \(stringValue)")
             }
         }

         // Runtime resolution: Int
         addAnyType(type: 10) // Output: "Int type: 10"
         // Runtime resolution: String
         addAnyType(type: "hello") // Output: "String type: hello"
         Any uses type erasure (wraps any type, no protocol constraints), while any Protocol only wraps types conforming to the specified protocol.
         Any loses static type safety (compiler can’t check type errors), so it should be used sparingly (e.g., Objective-C interop).
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
        
        
        /*
         This response is structured for technical interviews—clear, comparative, with core concepts, memory behavior, and practical distinctions highlighted (aligned with Swift/ObjC best practices):
         Opening: Core Definition Distinction
         First, let’s clarify the fundamental nature of each:
         Objective-C Blocks: A language feature that encapsulates a unit of code (like a function) as an Objective-C object (conforms to NSObject protocol). They are Objective-C’s implementation of closures, tied to the ObjC runtime.
         Swift Closures: A modern, type-safe implementation of anonymous functions (closures) in Swift—they are not inherently ObjC objects (unless bridged) and are optimized for Swift’s static typing, with advanced capture semantics and memory management.
         1. Memory Allocation (Stack vs. Heap)
         This is one of the most critical distinctions (and aligns with your note about escaping behavior):
         Objective-C Blocks
         Blocks have three memory allocation modes (managed by the ObjC runtime):
         Stack Blocks: Default for non-escaping blocks (declared and used within a single scope, no reference held outside). Allocated on the stack (fast, but destroyed when the scope exits).
         objc
         // Stack block (default, non-escaping)
         void (^stackBlock)(void) = ^{ NSLog(@"Stack block"); };
         stackBlock();
         Heap Blocks: Created when a block is copied (via copy method) or when it’s an escaping block (held in a property/global variable, passed to an async API). Allocated on the heap (persistent, but with reference counting overhead).
         objc
         // Heap block (escaping: stored in a property)
         @property (copy) void (^heapBlock)(void);
         self.heapBlock = ^{ NSLog(@"Heap block (copied)"); };
         Global Blocks: Blocks with no captured variables (static code). Allocated in global memory (no memory management).
         objc
         // Global block (no captured state)
         void (^globalBlock)(void) = ^{ NSLog(@"Global block"); };
         Swift Closures
         Swift simplifies memory allocation with explicit escaping semantics (@escaping):
         Non-Escaping Closures (default): Allocated on the stack (optimized, no ARC overhead). They cannot outlive the function they’re passed to (e.g., a closure parameter in a synchronous function like Array.forEach).
         swift
         // Non-escaping closure (stack-allocated, default)
         func processNonEscaping(closure: () -> Void) {
             closure() // Closure dies when processNonEscaping exits
         }
         processNonEscaping { print("Stack-allocated closure") }
         Escaping Closures (@escaping): Must be allocated on the heap (to outlive the function call). Used when the closure is stored (e.g., in a property) or executed asynchronously (e.g., network completion handlers).
         swift
         // Escaping closure (heap-allocated)
         var storedClosure: (() -> Void)?
         func processEscaping(closure: @escaping () -> Void) {
             storedClosure = closure // Closure outlives the function call
         }
         processEscaping { print("Heap-allocated closure") }
         Key Optimization: Swift automatically optimizes closures with no captured variables to be static (like ObjC global blocks) — no stack/heap allocation at all.
         2. Capture Semantics (Variable Capture)
         Both capture variables from their surrounding scope, but Swift is more explicit and safe:
         Objective-C Blocks
         Default Capture: Captures variables as const copies (immutable) unless marked __block (mutable).
         Object Capture: Captures Objective-C objects as strong references by default (risk of retain cycles if capturing self).
         objc
         // ObjC block capture (risk of retain cycle)
         self.heapBlock = ^{
             NSLog(@"Captured self: %@", self); // Strong reference to self
         };
         // Fix retain cycle: use __weak
         __weak typeof(self) weakSelf = self;
         self.heapBlock = ^{
             NSLog(@"Weak self: %@", weakSelf);
         };
         __block Modifier: Makes captured variables mutable and changes capture semantics (no longer a copy—direct reference).
         Swift Closures
         Default Capture: Captures values as immutable copies (like ObjC), but uses inout for mutable references (type-safe).
         Object Capture:
         Captures reference types as strong references by default (same as ObjC), but Swift requires explicit self (prevents accidental captures).
         Explicit weak/unowned capture with [weak self]/[unowned self] (safer, more readable than ObjC’s __weak).
         swift
         // Swift closure capture (explicit self + weak to avoid retain cycles)
         storedClosure = { [weak self] in
             guard let self = self else { return }
             print("Captured self safely: \(self)")
         }
         Value Type Capture: Captures structs/enums as copies (immutable by default); use mutating closures for mutable value type captures.
         
         */
        
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
        
        /*
         This response is structured for technical interviews—covering core definitions, use cases, syntax, internals, and practical examples (aligned with Swift best practices and common interview focus areas):
         1. Core Definition of Property Wrappers
         A property wrapper is a Swift language feature (introduced in Swift 5.1) that encapsulates the common logic for reading/writing properties (e.g., validation, persistence, thread safety, or default values) into a reusable type.
         Key purpose: Eliminate boilerplate code by separating the storage of a property from its behavior (e.g., instead of writing validation logic for 10 different properties, you define it once in a wrapper and apply it everywhere).
         Formally, a property wrapper is a struct/enum/class that conforms to the implicit contract of having:
         A wrappedValue property (the actual value being stored/accessed).
         Optional: projectedValue (for exposing additional functionality, e.g., a binding in SwiftUI).
         */
        
        /*
         枚举作为propertywrapper
         
         Why Enums CAN Implement Property Wrappers
         The key insight: Property wrappers do not require the wrapper type to have stored properties—they only require a wrappedValue (computed property) that fulfills the wrapper contract.
         Enums can define computed properties (and associated values for cases) — this is the loophole that allows them to act as property wrappers. The wrappedValue for an enum-based wrapper is implemented as a computed property (backed by enum case-associated values, not stored properties).
         Critical Contract for Property Wrappers
         A type qualifies as a property wrapper if it has:
         A wrappedValue (computed or stored) that handles get/set for the wrapped property.
         Optional: A projectedValue (computed) for additional functionality.
         Enums satisfy this contract by using case-associated values (their native way to hold state) and computed wrappedValue to interact with that state.
         3. Practical Example: Enum-Based Property Wrapper
         Let’s implement a property wrapper with an enum (e.g., a wrapper for "non-nil or default" string values) to demonstrate:
         
         // Enum-based property wrapper (no stored properties—uses associated values)
         @propertyWrapper
         enum DefaultNonEmptyString {
             // Case 1: Holds a valid non-empty string (state via associated value)
             case valid(String)
             // Case 2: Uses a default value (no associated value needed)
             case empty
             
             // Required: Computed wrappedValue (fulfills property wrapper contract)
             var wrappedValue: String {
                 get {
                     switch self {
                     case .valid(let str): return str
                     case .empty: return "Default Value"
                     }
                 }
                 set {
                     // Validation logic: set to .valid if non-empty, else .empty
                     if !newValue.isEmpty {
                         self = .valid(newValue)
                     } else {
                         self = .empty
                     }
                 }
             }
             
             // Initializer (required for property wrapper usage)
             init(wrappedValue initialValue: String) {
                 if !initialValue.isEmpty {
                     self = .valid(initialValue)
                 } else {
                     self = .empty
                 }
             }
         }

         // Usage: Apply the enum-based wrapper to a property
         struct Profile {
             @DefaultNonEmptyString var displayName: String = ""
             @DefaultNonEmptyString var bio: String = "Software Engineer"
         }

         // Test the wrapper
         var profile = Profile()
         print(profile.displayName) // Output: "Default Value" (enum case .empty)
         profile.displayName = "Jane Doe"
         print(profile.displayName) // Output: "Jane Doe" (enum case .valid("Jane Doe"))
         profile.displayName = ""
         print(profile.displayName) // Output: "Default Value" (switches back to .empty)
         
         
         This response addresses the core question (can property wrappers modify computed properties, including enum computed properties) with clear rules, practical examples, and compiler behavior—tailored for technical interviews:
         1. Core Rule: Property Wrappers CANNOT Modify Computed Properties (By Design)
         First, the definitive answer (a critical Swift language rule):
         Property wrappers can only be applied to stored properties (variables/constants that hold state directly). They cannot be applied to computed properties—regardless of whether the computed property is in a struct, class, or enum.
         This is not a limitation of enums or struct-based wrappers—it is a fundamental constraint of property wrappers in Swift. The compiler will throw an error if you attempt to apply a property wrapper to a computed property.
         
         */
        examples.append(SwiftExample(title: "27. Property Wrappers", explanation: "Custom logic for property access.") {
            struct Post {
                @Trimmed var title: String
            }
            
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
        
        /*
         Result is a generic enum (introduced in Swift 5) that explicitly represents the outcome of an operation with two possible states:
         Success: The operation completed successfully (holds a value of the expected type, e.g., Int, Data).
         Failure: The operation failed (holds an Error type to describe the failure).
         Formally, the Result type is defined in the Swift standard library as:
         swift
         enum Result<Success, Failure: Error> {
             case success(Success)
             case failure(Failure)
         }
         Generic parameter Success: The type of value returned on success (e.g., Int, String, [User]).
         Generic parameter Failure: Must conform to the Error protocol (restricts failure cases to valid error types).
         */
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
        
        
        /*
         inout is for value types (structs, enums, primitives) — reference types (class) are already passed by reference (modifying their properties does not require inout).
         
         
         1. Core Answer: No, Closures Do NOT Use inout to Capture/Modify Value Types
         The key clarification:
         Closures modify external value type variables through lexical scope capture (copy-on-write for value types) — NOT through the inout parameter mechanism. inout and closure capture are distinct compiler features with different underlying implementations.
         To understand why, we need to break down how closures capture value types (the actual mechanism) vs. what inout does (a separate pass-by-reference mechanism).
         2. How Closures Capture & Modify Value Types (Under the Hood)
         Swift closures follow lexical scoping (access variables from the scope where they are defined) — for value types (e.g., Int, Struct), the capture process works in two phases:
         Phase 1: Default Capture (Immutable Copy)
         By default, closures capture a copy of value type variables (immutable by default). If you modify the captured value, the compiler forces you to mark the closure as mutating (for non-escaping closures) or capture the variable as inout (rare, advanced):
         swift
         var count = 0 // Value type (Int)

         // Non-mutating closure: captures a COPY of count (cannot modify)
         let readOnlyClosure = {
             // count += 1 → COMPILER ERROR: Left side of mutating operator isn't mutable
             print(count) // Valid: read-only access to the copied count
         }
         Phase 2: Mutable Capture (Reference to the Original Variable)
         When you modify a value type inside a closure, the compiler does not use inout—instead, it captures a reference (pointer) to the original variable (not a copy) for the closure’s lifetime. This is a compiler optimization specific to closure capture (distinct from inout):
         swift
         var count = 0

         // Mutable closure: captures a REFERENCE to the original count (not inout)
         let mutableClosure = {
             count += 1 // Compiler allows modification: captures a reference to the original variable
         }

         mutableClosure()
         print(count) // Output: 1 (original variable modified)
         mutableClosure()
         print(count) // Output: 2 (reference persists for the closure’s lifetime)
         Critical Implementation Detail
         inout: Creates a temporary reference to the variable (only valid during the function call; the reference is invalid after the function returns).
         Closure capture (mutable value type): Creates a persistent reference to the variable (valid for the entire lifetime of the closure—even if the closure is stored/executed later).
         */
        examples.append(SwiftExample(title: "32. In-out Parameters", explanation: "Modify arguments passed to a function.") {
            func doubleIt(_ x: inout Int) { x *= 2 }
            var val = 5
            doubleIt(&val)
            print("Doubled: \(val)")
            
            var count = 0 // Value type (Int)

            
            // 闭包有类似 inout的功能，在需要修改里面数据的时候
            // Non-mutating closure: captures a COPY of count (cannot modify)
            let readOnlyClosure = {
                // count += 1 → COMPILER ERROR: Left side of mutating operator isn't mutable
                count += 1
                print(count) // Valid: read-only access to the copied count
            }
            readOnlyClosure()
            print(count) // Valid: read-only access to the copied count

        })
        
        examples.append(SwiftExample(title: "33. Computed Properties", explanation: "Properties that calculate a value.") {
            struct Rect {
                var width: Double, height: Double
                var area: Double { width * height }
            }
            print("Area: \(Rect(width: 5, height: 10).area)")
        })
        
        /*
         Enforce API Stability: Prevent breaking changes to critical logic (e.g., a payment processing class/method that must not be modified by subclasses).
         Performance Optimization: The Swift compiler uses final to optimize method dispatch (static dispatch instead of dynamic dispatch), reducing runtime overhead (critical for performance-sensitive code like UI rendering or algorithms).
         Intent Clarity: Explicitly communicate that a class/member is designed to be "closed for modification" (follows the Open/Closed Principle—open for extension, closed for modification).
         Prevent Buggy Overrides: Block accidental or malicious overriding of core logic (e.g., a security-related method like authenticateUser()).
         4. Critical Rules & Limitations (Interview Edge Cases)
         final only applies to classes and class members (it has no effect on structs/enums—they cannot be subclassed by default).
         final cannot be applied to static members (static members are already non-overridable).
         final takes precedence over open/public access control (even a public final class cannot be subclassed outside its module).
         
         // Non-final class (can be subclassed)
         class ParentClass {
             // Final method: Cannot be overridden
             final func calculate() -> Int {
                 return 42
             }
             
             // Regular method: Can be overridden
             func display() {
                 print("Parent implementation")
             }
             
             // Final computed property: Cannot be overridden
             final var version: String {
                 return "1.0"
             }
         }

         // Valid: Subclass the non-final ParentClass
         class ChildClass: ParentClass {
             // Valid: Override the non-final display() method
             override func display() {
                 print("Child implementation")
             }
             
             // ERROR: Cannot override final method 'calculate()'
             // override func calculate() -> Int { return 0 }
             
             // ERROR: Cannot override final property 'version'
             // override var version: String { return "2.0" }
         }
         
         */
        examples.append(SwiftExample(title: "34. Final Keyword", explanation: "Prevent inheritance or overriding.") {
            print("final class prevents subclassing.")
        })
        
        /*
         To demonstrate deep understanding, highlight key restrictions:
         No Stored Properties: Extensions can only add computed properties (not stored properties)—this preserves the memory layout of the original type.
         No Overrides: Extensions cannot override existing methods/properties of a type (subclassing is required for overrides).
         No Required Initializers: For classes, extensions cannot add required initializers (these must be defined in the original class).
         Access Control: Extensions have the same access level as the original type (you cannot access private members of the original type from an extension in a different file).
         4. Best Practices for Using Extensions (Interview Takeaway)
         Single Responsibility: Each extension should focus on one task (e.g., one extension for protocol conformance, another for utility methods).
         Avoid Over-Extension: Don’t clutter system types (e.g., String/Int) with niche methods—use extensions only for broadly useful functionality.
         Name Extensions (Optional): For large codebases, use // MARK: to label extensions (e.g., // MARK: - Printable Conformance).
         Targeted Extensions: Use generic constraints (e.g., extension Array where Element == Int) to limit extensions to specific type variants (avoids polluting all instances of a generic type).
         */
        examples.append(SwiftExample(title: "35. Extension", explanation: "Add functionality to existing types.") {
            print("5 squared: \(5.squaredValue)")
        })
        
        /*
         1. Core Definition of typealias
         A typealias (short for "type alias") is a Swift feature that creates a custom, readable name for an existing type—it does not define a new type, but rather a synonym (alias) for an existing one (including built-in types, custom types, generics, tuples, or protocol compositions).
         typealias is purely a compile-time convenience (no runtime overhead) — the compiler replaces the alias with the original type during compilation. Its core purpose is to improve code readability, reduce repetition, and make complex type signatures more expressive.
         2. Key Use Cases of typealias (With Code Examples)
         typealias solves 5 critical problems in Swift development—each with practical, interview-relevant examples:
         A. Simplify Complex Type Signatures
         The most common use case: making verbose/generic types (e.g., tuples, closures, generic collections) more readable:
         swift
         // Example 1: Simplify a tuple type
         typealias Coordinate = (x: Double, y: Double)
         let point: Coordinate = (10.5, 20.3)
         print("X: \(point.x), Y: \(point.y)") // Output: "X: 10.5, Y: 20.3"

         // Example 2: Simplify a closure type (critical for completion handlers)
         typealias NetworkCompletion = (Result<Data, Error>) -> Void

         // Use the alias in a function signature (cleaner than writing the full closure type)
         func fetchData(url: URL, completion: @escaping NetworkCompletion) {
             URLSession.shared.dataTask(with: url) { data, _, error in
                 if let error = error {
                     completion(.failure(error))
                     return
                 }
                 completion(.success(data ?? Data()))
             }.resume()
         }

         // Example 3: Simplify generic collection types
         typealias StringDictionary = [String: Any]
         typealias IntArray = [Int]

         let userData: StringDictionary = ["name": "Alice", "age": 30]
         let scores: IntArray = [90, 85, 95]
         B. Improve Readability for Domain-Specific Types
         typealias makes abstract types more meaningful in the context of your app’s domain (e.g., using UserId instead of String for user identifiers):
         swift
         // Domain-specific aliases (self-documenting code)
         typealias UserId = String
         typealias OrderId = Int
         typealias Temperature = Double

         // Usage (clearer intent than raw String/Int/Double)
         func fetchUser(id: UserId) {
             print("Fetching user with ID: \(id)")
         }

         func setTemperature(_ temp: Temperature) {
             print("Setting temperature to \(temp)°C")
         }

         fetchUser(id: "user_12345")
         setTemperature(22.5)
         C. Alias Protocol Compositions
         Simplify protocol compositions (multiple protocols combined with &) into a single readable name:
         swift
         // Protocol composition (verbose if reused)
         protocol Printable { func printDetails() }
         protocol Codable {} // Built-in protocol

         // Alias the composition for reusability
         typealias PrintableCodable = Printable & Codable

         // Use the alias to constrain a generic function
         func process<T: PrintableCodable>(_ value: T) {
             value.printDetails()
             // Encode value (since T conforms to Codable)
         }
         D. Alias Generic Types with Specific Constraints
         Create aliases for generic types with fixed generic parameters (reduces repetition):
         swift
         // Generic type (from Swift standard library)
         struct Stack<Element> {
             private var items: [Element] = []
             mutating func push(_ item: Element) { items.append(item) }
             mutating func pop() -> Element? { items.popLast() }
         }

         // Alias for a Stack of Int (avoids writing Stack<Int> repeatedly)
         typealias IntStack = Stack<Int>

         // Usage
         var numberStack = IntStack()
         numberStack.push(10)
         numberStack.push(20)
         print(numberStack.pop() ?? 0) // Output: 20
         E. Maintain Compatibility During Refactoring
         typealias can act as a temporary alias when renaming types (avoids breaking existing code):
         swift
         // Original type (to be renamed)
         class OldAPIClient { /* ... */ }

         // Temporary alias for backward compatibility
         typealias APIClient = OldAPIClient

         // Gradually migrate code to use APIClient, then remove OldAPIClient
         let client: APIClient = OldAPIClient()
         3. Critical Rules & Limitations (Interview Focus)
         To demonstrate deep understanding, highlight key restrictions:
         No New Type Creation: typealias is a synonym—not a new type. For example, typealias MyInt = Int means MyInt and Int are interchangeable (the compiler treats them as identical):
         swift
         typealias MyInt = Int
         let a: Int = 5
         let b: MyInt = a // Valid (no type conversion needed)
         Inheritance/Conformance: Aliases inherit the behavior of the original type. If the original type conforms to a protocol, the alias does too (no extra work needed).
         Scope: typealias is scoped to where it’s defined (e.g., a typealias inside a class is only accessible within that class unless marked public).
         4. Best Practices for Using typealias (Interview Takeaway)
         Use for Readability: Only create aliases that make code clearer (e.g., UserId instead of String)—avoid trivial aliases like typealias Str = String (adds no value).
         Domain-Specific Naming: Align aliases with your app’s domain (e.g., OrderId instead of Int for order identifiers) to make intent explicit.
         Avoid Overuse: Don’t create aliases for every type—reserve them for complex signatures (closures, tuples, protocol compositions) or domain-specific types.
         Consistent Naming: Follow S
         */
        examples.append(SwiftExample(title: "36. Typealias", explanation: "Give a new name to an existing type.") {
            typealias Kilometers = Int
            let distance: Kilometers = 100
            print("Distance: \(distance) km")
        })
        
        
        /*
         1. Core Definitions
         First, clarify the fundamental purpose of each type (the foundation of their differences):
         Any: Swift’s top-level type (the root of Swift’s type hierarchy) — it can represent an instance of any type whatsoever (value types: Int, String, Struct, Enum; reference types: Class; even function types).
         AnyObject: A protocol that only represents instances of class types (reference types) — it is equivalent to id in Objective-C and is primarily used for interoperability with Objective-C APIs.
         */
        examples.append(SwiftExample(title: "37. Any vs AnyObject", explanation: "Any for all types, AnyObject for class types.") {
            print("Any can hold value or reference types. AnyObject is for classes only.")
        })
        
        /*
         self (lowercase): Refers to the instance of the current type (a concrete object/value). It is used to access instance properties/methods, disambiguate variable names (e.g., self.name vs a parameter named name), or reference self in closures.
         Self (uppercase): Refers to the type itself (the metatype) — it acts as a placeholder for "the current type (or its subclass)" in protocols, extensions, or generic contexts. It is a type-level reference, not an instance reference.
         */
        examples.append(SwiftExample(title: "38. Self vs self", explanation: "Self for types, self for instances.") {
            print("self refers to the current instance. Self refers to the current type.")
        })
        
        /*
         First, set the baseline for both languages:
         Objective-C Enums: A thin wrapper around C enums—simple integer-based values with no type safety or advanced features.
         Swift Enums: A first-class, type-safe language feature (value types) that supports advanced functionality (associated values, methods, protocols) — one of Swift’s most powerful and distinctive features.

         */
        examples.append(SwiftExample(title: "39. Enum with Raw Values", explanation: "Predefined values for enums.") {
            enum Planet: Int { case mercury = 1, venus, earth }
            print("Earth raw value: \(Planet.earth.rawValue)")
        })
        
        examples.append(SwiftExample(title: "40. Enum with Associated Values", explanation: "Store extra info with enum cases.") {
            enum Barcode { case upc(Int, Int), qr(String) }
            let code = Barcode.qr("ABCDEFG")
            if case let .qr(s) = code { print("QR: \(s)") }
        })
        
        /*
         1. Core Definition of CaseIterable
         CaseIterable is a built-in Swift protocol (introduced in Swift 4.2) that enables an enum (or other type) to automatically generate a collection of all its cases. For enums (its primary use case), conforming to CaseIterable adds a static property allCases—an array containing every case of the enum, in the order they are defined.
         Key trait: CaseIterable is a protocol with a synthesized implementation (the Swift compiler automatically generates allCases for enums with no associated values—no manual code needed).
         2. Core Purpose & Value (Interview Focus)
         The primary role of CaseIterable is to:
         Eliminate manual, error-prone code for enumerating all cases of an enum (e.g., writing [.case1, .case2, .case3] by hand). It ensures consistency, reduces boilerplate, and prevents bugs from missing/duplicating cases when the enum is updated.
         3. Practical Examples (Interview-Ready Code)
         A. Basic Usage (Enum with No Associated Values)
         This is the most common scenario—enums with simple cases (the compiler synthesizes allCases automatically):
         swift
         // Conform enum to CaseIterable (no extra code needed)
         enum Direction: CaseIterable {
             case left
             case right
             case up
             case down
         }

         // Access all cases via the synthesized allCases property
         for direction in Direction.allCases {
             print("Direction: \(direction)")
         }
         // Output:
         // Direction: left
         // Direction: right
         // Direction: up
         // Direction: down

         // Use allCases for validation/checks
         let allDirectionNames = Direction.allCases.map { $0.rawValue } // If using raw values
         print(allDirectionNames) // ["left", "right", "up", "down"] (if rawValue is String)
         */
        examples.append(SwiftExample(title: "41. CaseIterable", explanation: "Loop through all enum cases.") {
            enum Direction: CaseIterable {
                case north, south, east, west
            }
            print("All cases: \(Direction.allCases.count)")
            
        })
        
        
        
        /*
         This response clarifies the scope of static in Swift and its mapping to Objective-C’s class methods/static variables—tailored for technical interviews:
         1. Core Answer: static in Swift (What It Modifies)
         First, confirm your observation (with precise boundaries):
         Yes – in Swift, static is exclusively used to modify type-level properties (stored/computed) and type-level methods/subscripts (collectively called "type members"). It does not modify instance members, classes/enums/structs themselves, or other language constructs (e.g., closures, parameters).
         Key clarification:
         static marks a member as belonging to the type itself (not instances) — this is its only role in Swift.
         It applies to:
         Stored properties (e.g., static let shared = Singleton())
         Computed properties (e.g., static var environment: String { ... })
         Methods (e.g., static func validateKey(_ key: String) -> Bool)
         Subscripts (rare, but valid: static subscript(index: Int) -> Self { ... })
         2. Swift static vs Objective-C (Class Methods / Static Variables)
         The mapping is mostly equivalent but with critical nuance—below is a side-by-side breakdown:
         A. Swift static func ↔ Objective-C Class Methods (+ Methods)
         Swift static methods are directly equivalent to Objective-C class methods (marked with + instead of - for instance methods):
         
         */
        examples.append(SwiftExample(title: "42. Static vs Class members", explanation: "Static prevents overriding, class allows it.") {
            print("Static: Cannot be overridden in subclasses. Class: Can be.")
        })
        
        examples.append(SwiftExample(title: "43. Escaping Closures", explanation: "Closure that outlives the function.") {
            print("@escaping is needed if closure is stored or used later.")
        })
        
        /*
         First, anchor to your example’s key point:
         @autoclosure is a Swift attribute that automatically wraps an expression in a zero-argument closure ( () -> T ). It lets you pass a normal expression (e.g., 2 > 1) to a function expecting a closure parameter—eliminating the need to write explicit closure syntax (e.g., { 2 > 1 }).
         */
        examples.append(SwiftExample(title: "44. Autoclosures", explanation: "Automatically wraps an expression in a closure.") {
            func logIfTrue(_ condition: @autoclosure () -> Bool) {
                if condition() { print("True!") }
            }
            logIfTrue(2 > 1)
        })
        
        
        /*
         An opaque type (marked with the some keyword) is a Swift feature that lets you return a specific, concrete type from a function/method while hiding its exact identity (e.g., some Collection instead of Array<Int>).
         
         It preserves the type’s "identity" (e.g., its associated types, methods) but hides the concrete implementation—balancing abstraction and type safety.
         In short:
         Concrete type: The function returns one specific type (e.g., Array<Int>), not multiple types.
         Opaque abstraction: Callers only see the protocol/type constraint (e.g., some Collection), not the concrete type.
         
         2. Why Opaque Types Exist (Core Value)
         Opaque types solve a critical limitation of protocol return types:
         A protocol return type (e.g., func f() -> Collection) allows returning any conforming type (e.g., Array<Int> or Set<Int>) but loses type identity (callers cannot use type-specific features like Array’s random access).
         An opaque type (e.g., func f() -> some Collection) returns one specific conforming type (e.g., only Array<Int>) and preserves full type identity (callers get all features of the concrete type, even if they don’t know its name).
         */
        examples.append(SwiftExample(title: "45. Opaque Types (some)", explanation: "Hide concrete return type but keep identity.") {
            
            // Function with opaque return type (some Collection)
            // Returns Array<Int> (concrete type) but hides it behind "some Collection"
            func makeNumbers() -> some Collection<Int> {
                return [1, 2, 3, 4] // Concrete type: Array<Int>
            }

            // Usage: Caller knows it's a Collection<Int> (can use Collection methods)
            let numbers = makeNumbers()
            print(numbers.count) // 4 (Collection feature)
            print(numbers.first!) // 1 (Collection feature)

            // Caller CANNOT access Array-specific methods (e.g., append) directly
            // numbers.append(5) → ERROR: Value of type 'some Collection<Int>' has no member 'append'

            // But the type identity is preserved (compiler knows it's Array<Int> internally)
            if let arr = numbers as? [Int] {
                var mutableArr = arr
                mutableArr.append(5) // Valid (cast reveals concrete type)
                print(mutableArr) // [1,2,3,4,5]
            }
            
            
            // 隐藏具体是 Array 还是 Set，只暴露“遵循 Collection 协议”
            func getCollection() -> some Collection {
                return [1, 2, 3] // 可以返回 Array<Int>
                // 也可以返回 Set([1,2,3])，但同一函数只能返回一种
            }
            
        })
        
        /*
         This response explains dynamic member lookup (the feature in your example) with core definitions, practical code, use cases, and interview-focused insights:
         1. Core Definition (Matching Your Example)
         First, anchor to your code snippet:
         @dynamicMemberLookup is a Swift attribute that enables dynamic access to "members" (properties/fields) at runtime—even if the member (e.g., anything in your example) is not defined as a static property of the type. Instead of throwing a compile error for p.anything, Swift redirects the lookup to a special method (subscript(dynamicMember:)) that you implement to handle the dynamic lookup logic.
         */
        examples.append(SwiftExample(title: "46. Dynamic Member Lookup", explanation: "Access properties dynamically at runtime.") {
            let p = DynamicPerson()
            print(p.anything)
        })
        
        /*
         1. Core Definition (Matching Your Example)
         First, anchor to your code snippet:
         Mirror is Swift’s built-in introspection (reflection) API that lets you examine the structure of an instance at runtime—including its properties, methods, and associated values (even if you don’t have compile-time access to the type’s definition). In your example, Mirror parses a User struct instance to extract its property labels (id/name) and values (1/Alice), enabling runtime inspection of statically defined types.
         Key distinction:
         Introspection (Mirror): Inspect the structure of an instance (what properties it has, their names/values).
         Not full reflection: Unlike languages like Java/C#, Swift’s Mirror is read-only (you cannot modify properties/methods at runtime—only inspect them).
         */
        examples.append(SwiftExample(title: "47. Mirror (Introspection) 内省", explanation: "Examine instance properties at runtime.") {
            struct User { let id: Int; let name: String }
            let u = User(id: 1, name: "Alice")
            let mirror = Mirror(reflecting: u)
            for child in mirror.children {
                print("\(child.label!): \(child.value)")
            }
            
            
            struct Product {
                var sku = ""
                var price = 0.1
                
            }
            struct User1 {
                var id = 1
                var name = ""
            }
            func instanceToDictionary<T>(_ instance: T) -> [String: Any] {
                // Compile time: T is resolved to concrete type (User/Product)
                // Runtime: Print the resolved concrete type
                print("Resolved concrete type of T: \(T.self)")
                
                var dict = [String: Any]()
                let mirror = Mirror(reflecting: instance)
                for child in mirror.children {
                    guard let label = child.label else { continue }
                    dict[label] = child.value
                }
                return dict
            }

            let u1 = User1(id: 1, name: "Alice")
            instanceToDictionary(u1) // Output: Resolved concrete type of T: User

            let p = Product(sku: "ABC123", price: 19.99)
            instanceToDictionary(p) // Output: Resolved concrete type of T: Product
        })
        
        
        examples.append(SwiftExample(title: "48. Range vs ClosedRange", explanation: "0..<5 vs 0...5.") {
            print("Range (..<): Excludes end. ClosedRange (...): Includes end.")
        })
        
        examples.append(SwiftExample(title: "49. Variadic Parameters", explanation: "Accept zero or more values of a type.") {
            func sum(_ numbers: Int...) -> Int {
                numbers.reduce(0, +)
            }
            print("Sum 1,2,3: \(sum(1, 2, 3))")
        })
        
        examples.append(SwiftExample(title: "50. Custom Operators", explanation: "Define your own symbols.") {
            print("2 ** 3 = \(2.0 ** 3.0)")
        })
        
        return examples
    }
}
