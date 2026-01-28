import UIKit

/// 二叉树层序遍历算法演示视图控制器
class LevelOrderTraversalViewController: UIViewController {
    
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
        title = "Level Order Traversal"
        view.backgroundColor = .white
        setupUI()
        testLevelOrder()
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
        explanationLabel.text = "Level Order Traversal Algorithm:\n\n1. Uses a queue to process nodes level by level\n2. For each level, process all nodes before moving to the next level\n3. Time complexity: O(n), where n is the number of nodes\n4. Space complexity: O(n) for the queue"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 二叉树层序遍历算法实现
    /// - Parameter root: 二叉树的根节点
    /// - Returns: 按层输出的二叉树节点值
    /// 思路：使用队列实现广度优先搜索（BFS）
    /// 1. 初始化一个队列，将根节点入队
    /// 2. 当队列不为空时，记录当前队列的大小（即当前层的节点数）
    /// 3. 遍历当前层的所有节点，将它们的值加入结果集
    /// 4. 将当前层节点的左子节点和右子节点入队
    /// 5. 重复上述过程，直到队列为空
    /// 6. 时间复杂度：O(n)，空间复杂度：O(n)
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        // 如果根节点为空，返回空数组
        guard let root = root else { return [] }
        
        // 结果数组，用于存储按层输出的节点值
        var result = [[Int]]()
        // 队列，用于广度优先搜索
        var queue = [TreeNode]()
        queue.append(root)
        
        // 当队列不为空时，继续遍历
        while !queue.isEmpty {
            // 当前层的节点数
            let levelSize = queue.count
            // 当前层的节点值数组
            var currentLevel = [Int]()
            
            // 遍历当前层的所有节点
            for _ in 0..<levelSize {
                // 出队一个节点
                let node = queue.removeFirst()
                // 将节点值加入当前层数组
                currentLevel.append(node.val)
                
                // 左子节点入队
                if let left = node.left {
                    queue.append(left)
                }
                // 右子节点入队
                if let right = node.right {
                    queue.append(right)
                }
            }
            // 将当前层数组加入结果数组
            result.append(currentLevel)
        }
        return result
    }
    
    /// 测试二叉树层序遍历算法
    /// 思路：
    /// 1. 构建一个测试二叉树
    /// 2. 调用层序遍历算法
    /// 3. 显示测试结果
    func testLevelOrder() {
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
        
        // 调用层序遍历算法
        let result = levelOrder(root)
        // 显示测试结果
        textView.text = "Binary Tree:\n    3\n   / \\n  9  20\n    /  \\n   15   7\n\nLevel Order Traversal Result:\n\(result)"
    }
}
