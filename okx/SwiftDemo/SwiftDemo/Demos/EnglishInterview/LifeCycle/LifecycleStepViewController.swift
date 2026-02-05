import UIKit

class LifecycleStepViewController: UIViewController {
    
    private let stepId: String
    private let step: LifecycleStep
    
    private let scrollView = UIScrollView()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    init(stepId: String) {
        self.stepId = stepId
        guard let step = LifecycleStep.steps[stepId] else {
            fatalError("Step not found: \(stepId)")
        }
        self.step = step
        super.init(nibName: nil, bundle: nil)
        self.title = step.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // Explanation
        addLabel(text: "Explanation:", font: .boldSystemFont(ofSize: 18))
        addLabel(text: step.explanation, font: .systemFont(ofSize: 16))
        
        // Code
        addLabel(text: "Code Example:", font: .boldSystemFont(ofSize: 18))
        let codeLabel = addLabel(text: step.codeExample, font: .monospacedSystemFont(ofSize: 14, weight: .regular))
        codeLabel.backgroundColor = .secondarySystemBackground
        codeLabel.layer.cornerRadius = 8
        codeLabel.clipsToBounds = true
        
        // Role
        addLabel(text: "Role:", font: .boldSystemFont(ofSize: 18))
        addLabel(text: step.role, font: .systemFont(ofSize: 16), color: .systemBlue)
        
        // Buttons
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.distribution = .fillEqually
        
        let demoButton = createButton(title: "Show Demo VC", action: #selector(showDemo))
        buttonStack.addArrangedSubview(demoButton)
        
        if step.nextStepId != nil {
            let nextButton = createButton(title: "Next Step", action: #selector(showNext))
            buttonStack.addArrangedSubview(nextButton)
        }
        
        stackView.addArrangedSubview(buttonStack)
    }
    
    @discardableResult
    private func addLabel(text: String, font: UIFont, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
        return label
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func showDemo() {
        guard let className = step.demoVCClassName else { return }
        
        let vc: UIViewController
        switch className {
        case "PureCodeDemoVC":
            vc = PureCodeDemoVC(customTitle: "Pure Code Demo", dataSource: ["Item 1", "Item 2"])
        case "XibDemoVC":
            // Normally would load from XIB, but we'll mock it if XIB is missing
            vc = XibDemoVC(data: "Passed from Step Controller")
        case "StoryboardDemoVC":
            vc = StoryboardDemoVC()
        case "ViewDidLoadDemoVC":
            vc = ViewDidLoadDemoVC()
        case "AppearanceDemoVC":
            vc = AppearanceDemoVC()
        case "LayoutDemoVC":
            vc = LayoutDemoVC()
        case "DisappearanceDemoVC":
            vc = DisappearanceDemoVC()
        case "DeinitDemoVC":
            vc = DeinitDemoVC()
        default:
            vc = UIViewController()
            vc.view.backgroundColor = .white
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showNext() {
        guard let nextId = step.nextStepId else { return }
        let nextVC = LifecycleStepViewController(stepId: nextId)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
