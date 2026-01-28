import UIKit

/// 二叉树最大深度算法演示视图控制器
class MaxDepthViewController: UIViewController {
    
    /// 二叉树节点定义
    /// 思路：使用类定义二叉树节点，包含值、左子节点和右子节点
    class TreeNode {
        var val: Int
        var left: TreeNode?
        var right: TreeNode?
        
        /// 初始化二叉树节点
        /// - Parameter val: 节点的值
        init(_ val: Int) {
            self.val = val
            self.left = nil
            self.right = nil
        }
    }
    
    /// 用于显示测试结果的文本视图
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Max Depth of Binary Tree"
        view.backgroundColor = .white
        setupUI()
        testMaxDepth()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置文本视图，用于显示测试结果
        textView.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 300)
        textView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.textAlignment = .left
        view.addSubview(textView)
        
        // 添加算法说明标签
        let explanationLabel = UILabel()
        explanationLabel.frame = CGRect(x: 20, y: 420, width: view.frame.width - 40, height: 150)
        explanationLabel.text = "Max Depth Algorithm:\n\n1. Uses recursive DFS (Depth-First Search) approach\n2. Base case: Empty node has depth 0\n3. Recursive case: Max depth of left and right subtrees + 1\n4. Time complexity: O(n), where n is the number of nodes\n5. Space complexity: O(h), where h is the height of the tree (due to recursion stack)"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试二叉树最大深度算法
    /// 思路：
    /// 1. 构建一个测试二叉树
    /// 2. 调用最大深度算法
    /// 3. 显示测试结果
    func testMaxDepth() {
        // 构建测试二叉树：
        //     3
        //    / \
        //   9  20
        //     /  \
        //    15   7
        let root = TreeNode(3)
        root.left = TreeNode(9)
        root.right = TreeNode(20)
        root.right?.left = TreeNode(15)
        root.right?.right = TreeNode(7)
        
        // 调用最大深度算法
        let depth = maxDepth(root)
        // 显示测试结果
        textView.text = "Binary Tree:\n    3\n   / \\n  9  20\n    /  \\n   15   7\n\nMax Depth Result:\n\(depth)"
    }
    
    /// 计算二叉树的最大深度
    /// - Parameter root: 二叉树的根节点
    /// - Returns: 二叉树的最大深度
    /// 思路：使用递归深度优先搜索（DFS）方法
    /// 1. 基本情况：空节点的深度为0
    /// 2. 递归情况：左子树和右子树的最大深度 + 1（当前节点）
    /// 3. 时间复杂度：O(n)，空间复杂度：O(h)，其中h是树的高度（递归栈的深度）
    func maxDepth(_ root: TreeNode?) -> Int {
        // 基本情况：空节点的深度为0
        guard let root = root else {
            return 0
        }
        // 递归计算左子树的深度
        let leftDepth = maxDepth(root.left)
        // 递归计算右子树的深度
        let rightDepth = maxDepth(root.right)
        // 返回左子树和右子树的最大深度 + 1（当前节点）
        return max(leftDepth, rightDepth) + 1
    }
}
