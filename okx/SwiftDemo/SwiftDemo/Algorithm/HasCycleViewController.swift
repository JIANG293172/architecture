import UIKit

class HasCycleViewController: UIViewController {
    
    // 定义链表节点
    class ListNode {
        var val: Int
        var next: ListNode?
        
        init(_ val: Int) {
            self.val = val
            self.next = nil
        }
    }
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Linked List Cycle Detection"
        view.backgroundColor = .white
        setupUI()
        testHasCycle()
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
        explanationLabel.text = "Linked List Cycle Detection Algorithm:\n\n1. Uses Floyd's Tortoise and Hare algorithm (two pointers)\n2. Slow pointer moves one step at a time\n3. Fast pointer moves two steps at a time\n4. If they meet, there's a cycle; if fast reaches end, no cycle\n5. Time complexity: O(n)\n6. Space complexity: O(1)"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
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
    
    func hasCycle(_ head: ListNode?) -> Bool {
        guard head != nil, head?.next != nil else {
            return false
        }
        
        var slow = head
        var fast = head?.next
        
        while slow !== fast {
            if fast == nil || fast?.next == nil {
                return false
            }
            
            slow = slow?.next
            fast = fast?.next?.next
        }
        return true
    }
}
