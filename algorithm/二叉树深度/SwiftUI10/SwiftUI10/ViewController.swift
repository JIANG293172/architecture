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
        
        testMaxDepth()
    }

    func testMaxDepth() {
        // 构建二叉树
        let root = TreeNode(3)
        root.left = TreeNode(9)
        root.right = TreeNode(20)
        root.right?.left = TreeNode(15)
        root.right?.right = TreeNode(7)
        
        print(maxDepth(root)) // 输出 3
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
