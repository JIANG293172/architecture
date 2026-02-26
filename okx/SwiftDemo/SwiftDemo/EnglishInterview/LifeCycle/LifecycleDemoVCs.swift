import UIKit

// MARK: - Step-by-Step Lifecycle Demo VCs

class PureCodeDemoVC: UIViewController {
    var customTitle: String
    var dataSource: [String]?

    init(customTitle: String, dataSource: [String]?) {
        self.customTitle = customTitle
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        self.title = customTitle
        print("📌 [PureCodeDemoVC] init complete")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Programmatic VC Loaded via loadView()\nCheck console for lifecycle logs."
        label.textAlignment = .center
        label.numberOfLines = 0

        rootView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: rootView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20)
        ])

        self.view = rootView
        print("📌 [PureCodeDemoVC] loadView called")
    }
}

class XibDemoVC: UIViewController {
    @IBOutlet weak var contentLabel: UILabel!
    var data: String = "Default XIB Data"

    convenience init(data: String) {
        self.init(nibName: "XibDemoVC", bundle: nil)
        self.data = data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel?.text = "Loaded from XIB\nData: \(data)"
        print("📌 [XibDemoVC] viewDidLoad")
    }
}

class StoryboardDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let label = UILabel(frame: view.bounds)
        label.text = "Loaded from Storyboard (Simulated)"
        label.textAlignment = .center
        view.addSubview(label)
        print("📌 [StoryboardDemoVC] viewDidLoad")
    }
}

class ViewDidLoadDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        print("📌 [ViewDidLoadDemoVC] viewDidLoad - Setting up UI")
    }
}

class AppearanceDemoVC: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("📌 [AppearanceDemoVC] viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("📌 [AppearanceDemoVC] viewDidAppear")
    }
}

class LayoutDemoVC: UIViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("📌 [LayoutDemoVC] viewWillLayoutSubviews")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("📌 [LayoutDemoVC] viewDidLayoutSubviews")
    }
}

class DisappearanceDemoVC: UIViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("📌 [DisappearanceDemoVC] viewWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("📌 [DisappearanceDemoVC] viewDidDisappear")
    }
}

class DeinitDemoVC: UIViewController {
    deinit {
        print("📌 [DeinitDemoVC] deinit - Memory released")
    }
}
