import UIKit

class CombineDemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let topics: [(id: Int, title: String, vcClass: UIViewController.Type)] = [
        (131, "What is Combine?", CombineDefinitionDemoVC.self),
        (132, "What is a Publisher?", PublisherDemoVC.self),
        (133, "What is a Subscriber?", SubscriberDemoVC.self),
        (134, "What is a Subscription?", SubscriptionDemoVC.self),
        (135, "Subjects: Passthrough vs CurrentValue", SubjectDemoVC.self),
        (136, "sink vs assign", SinkVsAssignDemoVC.self),
        (137, "assign(to:on:)", AssignToOnDemoVC.self),
        (138, "AnyCancellable & Set", AnyCancellableDemoVC.self),
        (139, "map and filter", MapAndFilterDemoVC.self),
        (140, "flatMap", FlatMapDemoVC.self),
        (141, "combineLatest", CombineLatestDemoVC.self),
        (142, "zip", ZipDemoVC.self),
        (143, "debounce vs throttle", DebounceVsThrottleDemoVC.self),
        (144, "eraseToAnyPublisher()", EraseToAnyPublisherDemoVC.self),
        (145, "Error Handling (Retry/Catch)", ErrorHandlingDemoVC.self),
        (146, "Scheduler (Timing & Context)", SchedulerDemoVC.self),
        (147, "receive(on:) vs subscribe(on:)", ReceiveVsSubscribeDemoVC.self),
        (148, "@Published", PublishedPropertyDemoVC.self),
        (149, "Just Publisher", JustPublisherDemoVC.self),
        (150, "Empty Publisher", EmptyPublisherDemoVC.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Combine Framework Demos"
        view.backgroundColor = .white
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension CombineDemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let topic = topics[indexPath.row]
        cell.textLabel?.text = "\(topic.id). \(topic.title)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topic = topics[indexPath.row]
        let vc = topic.vcClass.init()
        vc.title = topic.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
