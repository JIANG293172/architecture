import UIKit

/// 链表环检测算法演示视图控制器
class HasCycleViewController: UIViewController {
    
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
        title = "Linked List Cycle Detection"
        view.backgroundColor = .white
        setupUI()
        testHasCycle()
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
        explanationLabel.text = "Linked List Cycle Detection Algorithm:\n\n1. Uses Floyd's Tortoise and Hare algorithm (two pointers)\n2. Slow pointer moves one step at a time\n3. Fast pointer moves two steps at a time\n4. If they meet, there's a cycle; if fast reaches end, no cycle\n5. Time complexity: O(n)\n6. Space complexity: O(1)"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试链表环检测算法
    /// 思路：
    /// 1. 构建一个有环链表：1->2->3->2
    /// 2. 构建一个无环链表：1->2->3
    /// 3. 分别测试两个链表，验证算法的正确性
    func testHasCycle() {
        // 构建有环链表：1->2->3->2
        let head = ListNode(1)
        let node2 = ListNode(2)
        let node3 = ListNode(3)
        head.next = node2
        node2.next = node3
        node3.next = node2
        
        // 测试有环链表
        let hasCycleResult = hasCycle(head)
        
        // 构建无环链表：1->2->3
        let head2 = ListNode(1)
        head2.next = ListNode(2)
        head2.next?.next = ListNode(3)
        
        // 测试无环链表
        let noCycleResult = hasCycle(head2)
        
        // 构建测试结果文本
        let resultText = "Test 1: Linked List with Cycle (1->2->3->2)\nResult: \(hasCycleResult)\n\nTest 2: Linked List without Cycle (1->2->3)\nResult: \(noCycleResult)"
        
        textView.text = resultText
    }
    
    /// 检测链表是否存在环
    /// - Parameter head: 链表的头节点
    /// - Returns: 是否存在环
    /// 思路：使用Floyd's Tortoise and Hare算法（快慢指针法）
    /// 1. 慢指针每次移动一步，快指针每次移动两步
    /// 2. 如果链表存在环，快慢指针最终会相遇
    /// 3. 如果快指针到达链表末尾，则链表不存在环
    /// 4. 时间复杂度：O(n)，空间复杂度：O(1)
    func hasCycle(_ head: ListNode?) -> Bool {
        // 如果链表为空或只有一个节点，肯定不存在环
        guard head != nil, head?.next != nil else {
            return false
        }
        
        // 初始化慢指针和快指针
        var slow = head
        var fast = head?.next
        
        // 循环直到快慢指针相遇
        while slow !== fast {
            // 如果快指针到达链表末尾，不存在环
            if fast == nil || fast?.next == nil {
                return false
            }
            
            // 慢指针移动一步，快指针移动两步
            slow = slow?.next
            fast = fast?.next?.next
        }
        // 快慢指针相遇，存在环
        return true
    }
}
