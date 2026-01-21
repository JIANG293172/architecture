//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit

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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLevelOrder()
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
        
        print(levelOrder(root)) // 输出 [[3], [9, 20], [15, 7]]
    }
   
}
