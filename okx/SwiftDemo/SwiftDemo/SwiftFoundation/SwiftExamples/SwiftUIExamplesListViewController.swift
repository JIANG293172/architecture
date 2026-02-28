import UIKit
import SwiftUI

class SwiftUIExamplesListViewController: UITableViewController {
    
    private var examples: [(title: String, view: AnyView)] {
        var list: [(String, AnyView)] = []
        
        // 1. Custom Layout
        if #available(iOS 16.0, *) {
            list.append(("Custom Layout (Circular)", AnyView(CustomLayoutDemo())))
        } else {
            list.append(("Custom Layout (Circular)", AnyView(Text("Requires iOS 16+"))))
        }
        
        // 2. Hero Animation
        list.append(("Hero Animation (MatchedGeometry)", AnyView(MatchedGeometryDemo())))
        
        // 3. Scroll Sync
        list.append(("Scroll Sync (PreferenceKey)", AnyView(PreferenceKeyDemo())))
        
        // 4. Particle System
        list.append(("Particle System (Canvas)", AnyView(TimelineAnimationDemo())))
        
        return list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Advanced SwiftUI Examples"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let example = examples[indexPath.row]
        cell.textLabel?.text = example.title
        cell.textLabel?.textColor = .black
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        let hostingController = UIHostingController(rootView: example.view)
        hostingController.title = example.title
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
