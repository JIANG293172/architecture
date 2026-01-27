import UIKit

class MaxDepthViewController: UIViewController {
    
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
        title = "Max Depth of Binary Tree"
        view.backgroundColor = .white
        setupUI()
        testMaxDepth()
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
        explanationLabel.text = "Max Depth Algorithm:\n\n1. Uses recursive DFS (Depth-First Search) approach\n2. Base case: Empty node has depth 0\n3. Recursive case: Max depth of left and right subtrees + 1\n4. Time complexity: O(n), where n is the number of nodes\n5. Space complexity: O(h), where h is the height of the tree (due to recursion stack)"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    func testMaxDepth() {
        // 构建二叉树
        let root = TreeNode(3)
        root.left = TreeNode(9)
        root.right = TreeNode(20)
        root.right?.left = TreeNode(15)
        root.right?.right = TreeNode(7)
        
        let depth = maxDepth(root)
        textView.text = "Binary Tree:\n    3\n   / \\n  9  20\n    /  \\n   15   7\n\nMax Depth Result:\n\(depth)"
    }
    
    // 方法1：递归（DFS）
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0 // 空节点深度为0
        }
        // 左子树深度 + 右子树深度，取最大值 + 1（当前节点）
        let leftDepth = maxDepth(root.left)
        let rightDepth = maxDepth(root.right)
        return max(leftDepth, rightDepth) + 1
    }
}
