import UIKit
import Combine

/**
 * Combine Interview Principles (English Perspective):
 * 1. Declarative: You describe *what* to do with data, not *how* to do it step-by-step.
 * 2. Type-Safe: Publishers and Subscribers must match their Output and Failure types.
 * 3. Backpressure: Subscribers control the rate of data flow (via Demand), though most built-in sinks use unlimited demand.
 * 4. Memory Management: AnyCancellable handles the lifecycle, preventing memory leaks by automatically canceling on deinit.
 */

// MARK: - Base Class
class BaseCombineDemoVC: UIViewController {
    let textView = UITextView()
    let runButton = UIButton(type: .system)
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }
    
    private func setupBaseUI() {
        view.backgroundColor = .white
        
        runButton.setTitle("▶️ Run Detailed Demo", for: .normal)
        runButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        runButton.backgroundColor = .systemBlue
        runButton.setTitleColor(.white, for: .normal)
        runButton.layer.cornerRadius = 10
        runButton.addTarget(self, action: #selector(runDemo), for: .touchUpInside)
        
        textView.isEditable = false
        textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        view.addSubview(runButton)
        view.addSubview(textView)
        
        runButton.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            runButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            runButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            runButton.widthAnchor.constraint(equalToConstant: 200),
            runButton.heightAnchor.constraint(equalToConstant: 50),
            
            textView.topAnchor.constraint(equalTo: runButton.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func runDemo() {
        textView.text = "--- Demo Started ---\n"
        cancellables.removeAll()
    }
    
    func log(_ message: String) {
        DispatchQueue.main.async {
            self.textView.text += message + "\n"
            let range = NSMakeRange(self.textView.text.count - 1, 1)
            self.textView.scrollRangeToVisible(range)
            print(message)
        }
    }
}

// MARK: - 131. What is Combine?
class CombineDefinitionDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip: 
     * Define Combine as a "Declarative Swift API for processing values over time."
     * It unifies asynchronous tools like NotificationCenter, KVO, and completion handlers into a single stream-based pattern.
     */
    override func runDemo() {
        super.runDemo()
        log("Principles: Functional Reactive Programming (FRP).")
        log("Core components: Publisher (source), Operator (transformer), Subscriber (consumer).")
        
        // Example: Chaining multiple operators
        let publisher = [1, 2, 3, 4, 5].publisher
        
        publisher
            .filter { $0 % 2 == 0 } // Operator 1: Filter even
            .map { "Transformed \($0 * 10)" } // Operator 2: Multiply and stringify
            .sink(receiveCompletion: { completion in
                self.log("🏁 Stream finished: \(completion)")
            }, receiveValue: { value in
                self.log("📥 Received: \(value)")
            })
            .store(in: &cancellables)
    }
}

// MARK: - 132. What is a Publisher?
class PublisherDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * A Publisher is a protocol that defines how values and errors are emitted.
     * Crucially: "Publishers are lazy." They don't do work until a Subscriber is attached.
     */
    override func runDemo() {
        super.runDemo()
        log("Publisher protocol: <Output, Failure: Error>")
        
        // Just emits one value then completes
        let justPublisher = Just("Direct value from Just")
        
        justPublisher.sink(
            receiveCompletion: { self.log("Just completion: \($0)") },
            receiveValue: { self.log("Just value: \($0)") }
        ).store(in: &cancellables)
        
        // Fail publisher emits an error immediately
        enum DemoError: Error { case testError }
        let failPublisher = Fail<String, DemoError>(error: .testError)
        
        failPublisher.sink(
            receiveCompletion: { self.log("Fail completion: \($0)") },
            receiveValue: { self.log("Fail value: \($0)") }
        ).store(in: &cancellables)
    }
}

// MARK: - 133. What is a Subscriber?
class SubscriberDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * A Subscriber is the "sink" of the stream. It receives values and handles completion/failure.
     * Common subscribers: sink(), assign(to:on:), and custom subscribers using the Subscriber protocol.
     */
    override func runDemo() {
        super.runDemo()
        
        let subject = PassthroughSubject<String, Never>()
        
        // sink is the most flexible subscriber
        subject
            .sink(
                receiveCompletion: { completion in
                    self.log("Subscriber got completion: \(completion)")
                },
                receiveValue: { value in
                    self.log("Subscriber got value: \(value)")
                }
            )
            .store(in: &cancellables)
        
        log("Sending events...")
        subject.send("Hello")
        subject.send("World")
        subject.send(completion: .finished)
    }
}

// MARK: - 134. What is a Subscription?
class SubscriptionDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * The Subscription is the "bridge" or "contract" between Publisher and Subscriber.
     * It manages backpressure (demand) and lifecycle. When you cancel a subscription,
     * you break this bridge, stopping all future emissions.
     */
    override func runDemo() {
        super.runDemo()
        
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        log("Starting timer subscription...")
        let subscription = timerPublisher
            .sink { date in
                self.log("Timer ticked: \(date)")
            }
        
        // Manual cancellation after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.log("🛑 Manually canceling subscription...")
            subscription.cancel()
            self.log("No more ticks should appear.")
        }
    }
}

// MARK: - 135. Subjects: Passthrough vs CurrentValue
class SubjectDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * Subjects are "Publishers that you can manually inject values into" via send().
     * PassthroughSubject: No initial value. Good for "events" (button taps).
     * CurrentValueSubject: Has initial value. Good for "state" (login status).
     */
    override func runDemo() {
        super.runDemo()
        
        log("--- PassthroughSubject (Event-based) ---")
        let passthrough = PassthroughSubject<String, Never>()
        passthrough.send("Ignored") // No one is listening yet
        
        passthrough.sink { self.log("Passthrough received: \($0)") }.store(in: &cancellables)
        passthrough.send("Button Tap Event")
        
        log("\n--- CurrentValueSubject (State-based) ---")
        let currentValue = CurrentValueSubject<String, Never>("Initial State: LoggedOut")
        
        // Subscribers immediately get the current value upon subscription
        currentValue.sink { self.log("CurrentValue received: \($0)") }.store(in: &cancellables)
        
        currentValue.send("New State: LoggingIn")
        currentValue.send("New State: LoggedIn")
        
        // Late subscriber example
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.log("\n🕒 Late subscriber joins CurrentValueSubject:")
            currentValue.sink { self.log("Late subscriber got: \($0)") }.store(in: &self.cancellables)
        }
    }
}

// MARK: - 136. sink vs assign
class SinkVsAssignDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * sink: General purpose, uses a closure. Can handle values AND completion.
     * assign: Specifically for binding a value to a property of an object (Key-Path).
     * Warning: assign(to:on:) can create strong reference cycles if you're not careful.
     */
    @Published var statusText: String = "Ready"
    
    override func runDemo() {
        super.runDemo()
        
        log("--- sink: Flexible handling ---")
        Just("Task Completed")
            .sink { self.log("Sink handled: \($0)") }
            .store(in: &cancellables)
        
        log("\n--- assign: Direct binding ---")
        Just("Loading...")
            .assign(to: \.statusText, on: self)
            .store(in: &cancellables)
        
        log("Property 'statusText' is now: \(statusText)")
    }
}

// MARK: - 137. assign(to:on:)
class AssignToOnDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * Use assign(to:on:) for simple UI updates. 
     * IMPORTANT: It creates a strong reference to the 'on' object.
     * To avoid cycles, use assign(to: &...) with @Published properties in iOS 14+.
     */
    @Published var progress: Float = 0.0
    
    override func runDemo() {
        super.runDemo()
        
        let progressSource: [Float] = [0.1, 0.5, 1.0]
        
        // Using the safer assign(to: &...) pattern
        progressSource.publisher
            .assign(to: &$progress)
        
        $progress.sink { self.log("Progress updated to: \($0)") }.store(in: &cancellables)
    }
}

// MARK: - 138. AnyCancellable & Set
class AnyCancellableDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * AnyCancellable is the RAII (Resource Acquisition Is Initialization) token for Combine.
     * When it's deallocated, the subscription is automatically canceled.
     * We use Set<AnyCancellable> to manage multiple subscriptions' lifetimes with the VC.
     */
    override func runDemo() {
        super.runDemo()
        
        // If we don't store this, it dies immediately
        _ = Just("Discarded").sink { _ in self.log("This won't print if not stored") }
        
        // Correct way
        Just("Stored Event")
            .sink { self.log("Received: \($0)") }
            .store(in: &cancellables)
        
        log("Subscriptions in set: \(cancellables.count)")
    }
}

// MARK: - 139. map and filter
class MapAndFilterDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * map: Transforms every value emitted by a Publisher into a new value.
     * filter: screens values based on a boolean condition—only values that satisfy the condition are passed.
     */
    override func runDemo() {
        super.runDemo()
        
        log("--- map & filter ---")
        [1, 2, 3, 4, 5].publisher
            .map { number -> String in
                self.log("Map: \(number) -> 'Number: \(number)'")
                return "Number: \(number)"
            }
            .filter { transformedString in
                let number = Int(transformedString.components(separatedBy: ": ")[1])!
                let isEven = number % 2 == 0
                self.log("Filter: '\(transformedString)' is \(isEven ? "passed" : "dropped")")
                return isEven
            }
            .sink(receiveValue: { value in
                self.log("📥 Final Result: \(value)")
            })
            .store(in: &cancellables)
    }
}

// MARK: - 140. flatMap
class FlatMapDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * flatMap: Transforms value -> Publisher. Used for nested async work.
     * It 'flattens' the nested publishers into a single output stream.
     * Difference: map returns a value, flatMap returns a publisher.
     */
    override func runDemo() {
        super.runDemo()
        
        let userIds = [1, 2, 3].publisher
        
        log("--- flatMap: Chaining Async Tasks ---")
        userIds
            .flatMap(maxPublishers: .max(2)) { id in
                // Imagine this is a network request returning a Publisher
                self.log("🚀 Starting mock request for user \(id)")
                return self.mockNetworkCall(id: id)
            }
            .sink { self.log("✅ FlatMap received: \($0)") }
            .store(in: &cancellables)
    }
    
    private func mockNetworkCall(id: Int) -> AnyPublisher<String, Never> {
        return Just("Data for User \(id)")
            .delay(for: .milliseconds(500), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - 141. combineLatest
class CombineLatestDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * combineLatest waits for ALL publishers to emit at least once.
     * Then, it emits whenever ANY publisher updates, using the latest from others.
     * Use case: Form validation (Email + Password).
     */
    override func runDemo() {
        super.runDemo()
        let username = PassthroughSubject<String, Never>()
        let password = PassthroughSubject<String, Never>()
        
        username.combineLatest(password)
            .map { u, p in
                return u.count > 3 && p.count > 5
            }
            .sink { isValid in
                self.log("Form is valid: \(isValid)")
            }
            .store(in: &cancellables)
            
        log("Typing username: 'abc'")
        username.send("abc") // No output yet (waiting for password)
        
        log("Typing password: '123456'")
        password.send("123456") // Output: false (3, 6)
        
        log("Typing username: 'abcd'")
        username.send("abcd") // Output: true (4, 6)
    }
}

// MARK: - 142. zip
class ZipDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * zip pairs values strictly by order (1st with 1st, 2nd with 2nd).
     * It waits for a match. If one publisher is faster, its values are buffered.
     * Use case: Synchronizing two independent async tasks that must match up.
     */
    override func runDemo() {
        super.runDemo()
        let sourceA = PassthroughSubject<String, Never>()
        let sourceB = PassthroughSubject<Int, Never>()
        
        sourceA.zip(sourceB)
            .sink { self.log("✅ Zipped Pair: (\($0), \($1))") }
            .store(in: &cancellables)
            
        log("A sends 'Red'")
        sourceA.send("Red")
        
        log("A sends 'Blue'")
        sourceA.send("Blue") // Still nothing (waiting for B)
        
        log("B sends 1")
        sourceB.send(1) // Emits (Red, 1)
        
        log("B sends 2")
        sourceB.send(2) // Emits (Blue, 2)
    }
}

// MARK: - 143. debounce vs throttle
class DebounceVsThrottleDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * debounce: Waits for a "pause" in events. (Search bar input).
     * throttle: Emits at most once per interval. (Button spam protection).
     */
    let inputSubject = PassthroughSubject<String, Never>()
    
    override func runDemo() {
        super.runDemo()
        
        // Debounce: Only emits if no new input for 500ms
        inputSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { self.log("🔍 Debounce (Search for): \($0)") }
            .store(in: &cancellables)
            
        // Throttle: Emits the first/latest value in a 1s window
        inputSubject
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .sink { self.log("⚡ Throttle (Action): \($0)") }
            .store(in: &cancellables)
            
        log("Typing 'H'...")
        inputSubject.send("H")
        
        log("Typing 'He' rapidly...")
        inputSubject.send("He")
        
        log("Typing 'Hel' rapidly...")
        inputSubject.send("Hel")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.log("\n--- After 0.6s pause ---")
            self.log("Typing 'Hello'...")
            self.inputSubject.send("Hello")
        }
    }
}

// MARK: - 144. eraseToAnyPublisher()
class EraseToAnyPublisherDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * This is "Type Erasure". It hides the complex internal operator types
     * (e.g. Publishers.Map<Publishers.Filter<...>>) and exposes a clean AnyPublisher.
     * Crucial for API design: you don't want to expose implementation details.
     */
    override func runDemo() {
        super.runDemo()
        
        let publisher = [1, 2, 3].publisher
            .map { $0 * 10 }
            .filter { $0 > 15 }
            .eraseToAnyPublisher() // Without this, type is Publishers.Filter<Publishers.Map<...>>
            
        log("Clean API type: \(type(of: publisher))")
        publisher.sink { self.log("Received: \($0)") }.store(in: &cancellables)
    }
}

// MARK: - 145. Error Handling (Retry/Catch)
class ErrorHandlingDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * Combine provides robust error handling.
     * retry(n): Re-subscribes upon failure.
     * catch: Swaps a failed publisher with a fallback one.
     */
    enum APIError: Error { case serverDown }
    
    override func runDemo() {
        super.runDemo()
        var attempts = 0
        
        let flakyTask = Deferred {
            Future<String, APIError> { promise in
                attempts += 1
                self.log("Attempting API call \(attempts)...")
                if attempts < 3 {
                    promise(.failure(.serverDown))
                } else {
                    promise(.success("Server Response: 200 OK"))
                }
            }
        }
        
        flakyTask
            .retry(2) // Try up to 2 extra times
            .catch { error in
                self.log("Caught error: \(error). Returning cached data.")
                return Just("Cached Local Data")
            }
            .sink { self.log("Final UI Result: \($0)") }
            .store(in: &cancellables)
    }
}

// MARK: - 146. Scheduler (Timing & Context)
class SchedulerDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * Schedulers control *where* and *when* work happens.
     * Common: DispatchQueue.main, DispatchQueue.global(), RunLoop.main.
     */
    override func runDemo() {
        super.runDemo()
        
        log("Running on thread: \(Thread.current)")
        
        Just("Heavy Task result")
            .receive(on: DispatchQueue.global()) // Switch to background
            .map { result -> String in
                self.log("Processing on background thread: \(Thread.current)")
                return result.uppercased()
            }
            .receive(on: RunLoop.main) // Switch back to main for UI
            .sink { result in
                self.log("Final UI Update on: \(Thread.isMainThread ? "Main Thread" : "Background")")
                self.log("Result: \(result)")
            }
            .store(in: &cancellables)
    }
}

// MARK: - 147. receive(on:) vs subscribe(on:)
class ReceiveVsSubscribeDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * subscribe(on:): Affects the *upstream* - where the publisher starts its work.
     * receive(on:): Affects the *downstream* - where operators and subscribers receive values.
     * Most of the time, you only need receive(on: .main) for UI updates.
     */
    override func runDemo() {
        super.runDemo()
        
        let complexPublisher = Future<String, Never> { promise in
            self.log("🚀 Publisher work started on: \(Thread.current.description)")
            promise(.success("Work Completed"))
        }
        
        complexPublisher
            .subscribe(on: DispatchQueue.global()) // Start work on background
            .receive(on: RunLoop.main) // Receive results on main
            .sink { value in
                self.log("📥 Sink received '\(value)' on: \(Thread.isMainThread ? "Main Thread" : "Background")")
            }
            .store(in: &cancellables)
    }
}

// MARK: - 148. @Published
class PublishedPropertyDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * @Published is a property wrapper that automatically creates a publisher for a property.
     * Use $propertyName to access the publisher.
     * It's the foundation of data binding in SwiftUI and modern MVVM.
     */
    @Published var userScore: Int = 0
    
    override func runDemo() {
        super.runDemo()
        
        // Subscribe to changes
        $userScore
            .dropFirst() // Ignore the initial value (0)
            .sink { newValue in
                self.log("Score changed to: \(newValue)")
            }
            .store(in: &cancellables)
        
        log("Changing score to 50...")
        userScore = 50
        
        log("Changing score to 100...")
        userScore = 100
    }
}

// MARK: - 149. Just Publisher
class JustPublisherDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * Just: Emits a single value and then finishes immediately.
     * It cannot fail (Failure type is Never).
     * Useful for providing default values or wrapping synchronous values into publishers.
     */
    override func runDemo() {
        super.runDemo()
        
        Just("Only one value")
            .sink(
                receiveCompletion: { self.log("Just finished: \($0)") },
                receiveValue: { self.log("Just emitted: \($0)") }
            )
            .store(in: &cancellables)
    }
}

// MARK: - 150. Empty Publisher
class EmptyPublisherDemoVC: BaseCombineDemoVC {
    /**
     * Interview Tip:
     * Empty: Emits NO values and finishes immediately.
     * Useful for optional streams or when you want to complete without sending data.
     * parameter completeImmediately: If false, it never finishes (useful for 'never' streams).
     */
    override func runDemo() {
        super.runDemo()
        
        log("Starting Empty publisher...")
        Empty<String, Never>()
            .sink(
                receiveCompletion: { self.log("Empty finished: \($0)") },
                receiveValue: { self.log("This will never be called: \($0)") }
            )
            .store(in: &cancellables)
    }
}
