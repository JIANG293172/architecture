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
        
        // --- 1. Higher-Order Functions ---
        examples.append(SwiftExample(title: "1. Map", explanation: "Transforms each element in a collection.") {
            let numbers = [1, 2, 3]
            let squared = numbers.map { $0 * $0 }
            print("Map: [1, 2, 3] -> \(squared)")
        })
        
        examples.append(SwiftExample(title: "2. Filter", explanation: "Selects elements that satisfy a condition.") {
            let numbers = [1, 2, 3, 4, 5, 6]
            let evens = numbers.filter { $0 % 2 == 0 }
            print("Filter Evens: \(evens)")
        })
        
        examples.append(SwiftExample(title: "3. Reduce", explanation: "Combines all elements into a single value.") {
            let numbers = [1, 2, 3, 4]
            let sum = numbers.reduce(0, +)
            print("Reduce Sum: \(sum)")
        })
        
        examples.append(SwiftExample(title: "4. CompactMap", explanation: "Transforms elements and removes nil values.") {
            let strings = ["1", "two", "3", "four"]
            let numbers = strings.compactMap { Int($0) }
            print("CompactMap (valid ints): \(numbers)")
        })
        
        examples.append(SwiftExample(title: "5. FlatMap", explanation: "Flattens nested collections or unwraps nested optionals.") {
            let nested = [[1, 2], [3, 4], [5]]
            let flattened = nested.flatMap { $0 }
            print("FlatMap (flattened): \(flattened)")
        })
        
        examples.append(SwiftExample(title: "6. ForEach", explanation: "Iterates over each element (cannot use break/continue).") {
            [1, 2, 3].forEach { print("ForEach: \($0)") }
        })
        
        examples.append(SwiftExample(title: "7. Sorted", explanation: "Returns a sorted version of the collection.") {
            let unsorted = [3, 1, 4, 1, 5]
            print("Sorted: \(unsorted.sorted())")
        })
        
        examples.append(SwiftExample(title: "8. Partition", explanation: "Reorders elements based on a predicate.") {
            var numbers = [10, 5, 8, 2, 7]
            let pivot = numbers.partition(by: { $0 > 5 })
            print("Partitioned (split at index \(pivot)): \(numbers)")
        })
        
        // --- 2. Optionals & Basics ---
        examples.append(SwiftExample(title: "9. Optional Binding (if let)", explanation: "Safely unwrap optionals.") {
            let name: String? = "Swift"
            if let unwrapped = name { print("Unwrapped: \(unwrapped)") }
        })
        
        examples.append(SwiftExample(title: "10. Guard Statement", explanation: "Early exit from a function if condition isn't met.") {
            func greet(_ name: String?) {
                guard let name = name else { return }
                print("Hello, \(name)")
            }
            greet("Developer")
        })
        
        examples.append(SwiftExample(title: "11. Nil Coalescing (??)", explanation: "Provide a default value for an optional.") {
            let name: String? = nil
            print("User: \(name ?? "Guest")")
        })
        
        examples.append(SwiftExample(title: "12. Defer", explanation: "Code that runs just before the current scope exits.") {
            print("Step 1")
            defer { print("Step 3 (Deferred)") }
            print("Step 2")
        })
        
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
        examples.append(SwiftExample(title: "14. Struct (Value Type)", explanation: "Passed by copying.") {
            struct Point { var x: Int }
            var p1 = Point(x: 10)
            var p2 = p1
            p2.x = 20
            print("Struct: p1.x=\(p1.x), p2.x=\(p2.x)")
        })
        
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
        
        // --- 4. Protocols & Generics ---
        examples.append(SwiftExample(title: "17. Protocol Extensions", explanation: "Provide default implementations for protocols.") {
            PersonGreetable().greet()
        })
        
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
