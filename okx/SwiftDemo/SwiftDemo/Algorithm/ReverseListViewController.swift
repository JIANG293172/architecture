import UIKit

class ReverseListViewController: UIViewController {
    
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
        title = "Reverse Linked List"
        view.backgroundColor = .white
        setupUI()
        testReverseList()
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
        explanationLabel.text = "Reverse Linked List Algorithm:\n\n1. Uses iterative approach with three pointers\n2. Reverses the direction of pointers one by one\n3. Time complexity: O(n), where n is the number of nodes\n4. Space complexity: O(1), constant extra space"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    func testReverseList() {
        // 构建链表
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
    
    func reverseList(_ head: ListNode) -> ListNode? {
        var preNode = head
        var nextNode = head.next
        
        preNode.next = nil
        
        while nextNode != nil {
            let inNextNode = nextNode?.next

            nextNode?.next = preNode
            
            preNode = nextNode!
            nextNode = inNextNode
        }
        
        return preNode
    }
}
