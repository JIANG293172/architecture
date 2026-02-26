import Foundation

struct LifecycleStep {
    let id: String
    let title: String
    let explanation: String
    let codeExample: String
    let role: String
    let nextStepId: String?
    let demoVCClassName: String?
    
    static let steps: [String: LifecycleStep] = [
        "init": LifecycleStep(
            id: "init",
            title: "1. Pure Code Initialization (init & loadView)",
            explanation: "Programmatic approach to create a ViewController without any interface files.",
            codeExample: """
            class MyVC: UIViewController {
                var customTitle: String
                var dataSource: [String]?

                // 1. Custom Initializer
                init(customTitle: String, dataSource: [String]?) {
                    self.customTitle = customTitle
                    self.dataSource = dataSource
                    super.init(nibName: nil, bundle: nil)
                    self.title = customTitle
                    print("📌 Programmatic init complete")
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }

                // 2. Override loadView (Mandatory for custom root view)
                override func loadView() {
                    let rootView = UIView()
                    rootView.backgroundColor = .white
                    self.view = rootView
                    print("📌 loadView: Root view created manually")
                }
            }
            """,
            role: "Role: Full control over initialization and view hierarchy creation. Best for complex dynamic UIs.",
            nextStepId: "initNib",
            demoVCClassName: "PureCodeDemoVC"
        ),
        "initNib": LifecycleStep(
            id: "initNib",
            title: "2. XIB Initialization (init(nibName:bundle:))",
            explanation: "Loading a ViewController with a corresponding .xib file.",
            codeExample: """
            class XibDemoVC: UIViewController {
                @IBOutlet weak var contentLabel: UILabel!
                
                var data: String
                
                // Custom convenience initializer
                convenience init(data: String) {
                    self.init(nibName: "XibDemoVC", bundle: nil)
                    self.data = data
                }
                
                // Internal init used by convenience init
                override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
                    self.data = ""
                    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }
            """,
            role: "Role: Visual layout with XIB while maintaining control over custom initialization logic.",
            nextStepId: "initCoder",
            demoVCClassName: "XibDemoVC"
        ),
        "initCoder": LifecycleStep(
            id: "initCoder",
            title: "3. Storyboard Initialization (init(coder:))",
            explanation: "When a ViewController is instantiated from a Storyboard.",
            codeExample: """
            class StoryboardDemoVC: UIViewController {
                // This is called when loading from Storyboard
                required init?(coder: NSCoder) {
                    super.init(coder: coder)
                    print("📌 init(coder:) called")
                }
                
                override func awakeFromNib() {
                    super.awakeFromNib()
                    print("📌 awakeFromNib called")
                }
            }
            """,
            role: "Role: Required for Storyboard-based apps. Note: Custom properties must be set after init or via dependency injection.",
            nextStepId: "viewDidLoad",
            demoVCClassName: "StoryboardDemoVC"
        ),
        "viewDidLoad": LifecycleStep(
            id: "viewDidLoad",
            title: "4. viewDidLoad",
            explanation: "Called after the view controller's view has been loaded into memory.",
            codeExample: """
            override func viewDidLoad() {
                super.viewDidLoad()
                
                // One-time setup
                setupSubviews()
                configureConstraints()
                fetchInitialData()
                
                print("📌 viewDidLoad: Perfect for one-time initialization")
            }
            """,
            role: "Role: Main entry point for view setup. View bounds are NOT final here.",
            nextStepId: "viewWillAppear",
            demoVCClassName: "ViewDidLoadDemoVC"
        ),
        "viewWillAppear": LifecycleStep(
            id: "viewWillAppear",
            title: "5. viewWillAppear & viewDidAppear",
            explanation: "Called when the view is about to be added to the view hierarchy and after it has been added.",
            codeExample: """
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                // Update UI state before it's visible
                refreshData()
            }

            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                // Start animations, timers, or network requests
                startAnimations()
            }
            """,
            role: "Role: Appearance tracking and visibility-related tasks.",
            nextStepId: "layout",
            demoVCClassName: "AppearanceDemoVC"
        ),
        "layout": LifecycleStep(
            id: "layout",
            title: "6. viewWillLayoutSubviews & viewDidLayoutSubviews",
            explanation: "Called when the view controller's view is about to lay out its subviews and after layout is done.",
            codeExample: """
            override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
                // Last chance to modify layout before it's applied
            }

            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                // View bounds are now correct. Finalize geometry here.
            }
            """,
            role: "Role: Handle frame changes and final geometry setup.",
            nextStepId: "disappear",
            demoVCClassName: "LayoutDemoVC"
        ),
        "disappear": LifecycleStep(
            id: "disappear",
            title: "7. viewWillDisappear & viewDidDisappear",
            explanation: "Called when the view is about to be removed from the hierarchy and after it has been removed.",
            codeExample: """
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                // Save state, stop timers, hide keyboard
            }

            override func viewDidDisappear(_ animated: Bool) {
                super.viewDidDisappear(animated)
                // Clean up resources that are only needed when visible
            }
            """,
            role: "Role: Clean up and state preservation.",
            nextStepId: "deinit",
            demoVCClassName: "DisappearanceDemoVC"
        ),
        "deinit": LifecycleStep(
            id: "deinit",
            title: "8. deinit",
            explanation: "Called when the view controller is being deallocated from memory.",
            codeExample: """
            deinit {
                // Remove notification observers
                // Close file handles or connections
                print("📌 VC deallocated - No memory leaks!")
            }
            """,
            role: "Role: Final cleanup. Crucial for checking memory leaks.",
            nextStepId: nil,
            demoVCClassName: "DeinitDemoVC"
        )
    ]
}
