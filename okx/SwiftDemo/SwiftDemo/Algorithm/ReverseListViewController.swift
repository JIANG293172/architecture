import UIKit

/// 反转链表算法演示视图控制器
class ReverseListViewController: UIViewController {
    
    /// 链表节点定义
    /// 思路：使用类定义链表节点，包含值和指向下一个节点的指针
    class ListNode {
        var val: Int
        var next: ListNode?
        
        /// 初始化链表节点
        /// - Parameter val: 节点的值
        init(_ val: Int) {
            self.val = val
            self.next = nil
        }
    }
    
    /// 用于显示测试结果的文本视图
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reverse Linked List"
        view.backgroundColor = .white
        setupUI()
        testReverseList()
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
        explanationLabel.text = "Reverse Linked List Algorithm:\n\n1. Uses iterative approach with three pointers\n2. Reverses the direction of pointers one by one\n3. Time complexity: O(n), where n is the number of nodes\n4. Space complexity: O(1), constant extra space"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试反转链表算法
    /// 思路：
    /// 1. 构建一个测试链表
    /// 2. 打印原始链表
    /// 3. 调用反转链表算法
    /// 4. 打印反转后的链表
    func testReverseList() {
        // 构建测试链表：1 -> 2 -> 3 -> 4 -> 5
        let head = ListNode(1)
        head.next = ListNode(2)
        head.next?.next = ListNode(3)
        head.next?.next?.next = ListNode(4)
        head.next?.next?.next?.next = ListNode(5)
        
        // 打印原始链表
        var originalList = "Original List: "
        var currentNode = head
        while true {
            originalList += "\(currentNode.val)"
            if currentNode.next != nil {
                originalList += " -> "
                currentNode = currentNode.next!
            } else {
                break
            }
        }
        
        // 反转链表
        let reversedHead = reverseList(head)
        
        // 打印反转后的链表
        var reversedList = "\nReversed List: "
        var reversedCurrentNode = reversedHead
        while reversedCurrentNode != nil {
            reversedList += "\(reversedCurrentNode!.val)"
            if reversedCurrentNode?.next != nil {
                reversedList += " -> "
                reversedCurrentNode = reversedCurrentNode?.next
            } else {
                break
            }
        }
        
        textView.text = originalList + reversedList
    }
    
    /// 反转链表算法实现
    /// - Parameter head: 链表的头节点
    /// - Returns: 反转后的链表的头节点
    /// 思路：使用迭代方法，通过三个指针逐步反转链表
    /// 1. 初始化前一个节点为head，后一个节点为head.next
    /// 2. 将前一个节点的next指针置为nil（作为新的尾节点）
    /// 3. 循环处理剩余节点：
    ///    a. 保存下一个节点
    ///    b. 将当前节点的next指针指向前一个节点
    ///    c. 更新前一个节点和当前节点
    /// 4. 时间复杂度：O(n)，空间复杂度：O(1)
    func reverseList(_ head: ListNode) -> ListNode? {
        // 初始化前一个节点为head
        var preNode = head
        // 初始化后一个节点为head.next
        var nextNode = head.next
        
        // 将前一个节点的next指针置为nil（作为新的尾节点）
        preNode.next = nil
        
        // 循环处理剩余节点
        while nextNode != nil {
            // 保存下一个节点
            let inNextNode = nextNode?.next

            // 将当前节点的next指针指向前一个节点
            nextNode?.next = preNode
            
            // 更新前一个节点为当前节点
            preNode = nextNode!
            // 更新当前节点为保存的下一个节点
            nextNode = inNextNode
        }
        
        // 返回反转后的链表的头节点（即原链表的尾节点）
        return preNode
    }
}
