import UIKit
import AsyncDisplayKit

class FacebookFeedViewController: ASDKViewController<ASTableNode> {
    
    private let tableNode: ASTableNode
    private var feedData: [FacebookFeedModel] = FacebookFeedModel.mockData()
    
    override init() {
        self.tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facebook Feed (Texture)"
        view.backgroundColor = .white
        
        // Example of adding a refresh control to ASTableNode's view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableNode.view.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableNode.view.refreshControl?.endRefreshing()
            self.tableNode.reloadData()
        }
    }
}

// MARK: - ASTableDataSource
extension FacebookFeedViewController: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return feedData.count
    }
    
    // Texture's magic: Node Block
    // This allows the table node to initialize cells on a background thread!
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = feedData[indexPath.row]
        
        let cellNodeBlock = { () -> ASCellNode in
            return FacebookFeedCellNode(model: model)
        }
        
        return cellNodeBlock
    }
}

// MARK: - ASTableDelegate
extension FacebookFeedViewController: ASTableDelegate {
    
    // Optional: handle selection
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        print("Selected: \(feedData[indexPath.row].userName)")
    }
}
