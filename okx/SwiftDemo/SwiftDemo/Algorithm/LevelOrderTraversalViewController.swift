import UIKit

class LevelOrderTraversalViewController: UIViewController {
    
    // 定义二叉树节点
    class TreeNode {
        var val: Int
        var left: TreeNode?
        var right: TreeNode?
        init(_ val: Int) {
            self.val = val
            self.left = nil
            self.right = nil
        }
    }
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Level Order Traversal"
        view.backgroundColor = .white
        setupUI()
        testLevelOrder()
    }
    
    private func setupUI() {
        // Setup text view
        textView.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 300)
        textView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.textAlignment = .left
        view.addSubview(textView)
        
        // Add explanation label
        let explanationLabel = UILabel()
        explanationLabel.frame = CGRect(x: 20, y: 420, width: view.frame.width - 40, height: 150)
        explanationLabel.text = "Level Order Traversal Algorithm:\n\n1. Uses a queue to process nodes level by level\n2. For each level, process all nodes before moving to the next level\n3. Time complexity: O(n), where n is the number of nodes\n4. Space complexity: O(n) for the queue"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    // 二叉树层序遍历（按层输出）
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        
        var result = [[Int]]()
        var queue = [TreeNode]()
        queue.append(root)
        
        while !queue.isEmpty {
            let levelSize = queue.count
            var currentLevel = [Int]()
            
            // 遍历当前层的所有节点
            for _ in 0..<levelSize {
                let node = queue.removeFirst()
                currentLevel.append(node.val)
                
                // 入队下一层节点
                if let left = node.left {
                    queue.append(left)
                }
                if let right = node.right {
                    queue.append(right)
                }
            }
            result.append(currentLevel)
        }
        return result
    }
    
    // 测试用例
    func testLevelOrder() {
        let root = TreeNode(3)
        root.left = TreeNode(9)
        root.right = TreeNode(20)
        root.right?.left = TreeNode(15)
        root.right?.right = TreeNode(7)
        
        let result = levelOrder(root)
        textView.text = "Binary Tree:\n    3\n   / \\n  9  20\n    /  \\n   15   7\n\nLevel Order Traversal Result:\n\(result)"
    }
}
