//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift

class ListNode {
    var val: Int
    var next: ListNode?
    
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        testHasCycle()

    }
    
    
    func testHasCycle() {
        // 构建有环链表：1->2->3->2
        let head = ListNode(1)
        let node2 = ListNode(2)
        let node3 = ListNode(3)
        head.next = node2
        node2.next = node3
        node3.next = node2
        
        print(hasCycle(head)) // 输出 true
        
        // 构建无环链表：1->2->3
        let head2 = ListNode(1)
        head2.next = ListNode(2)
        head2.next?.next = ListNode(3)
        print(hasCycle(head2)) // 输出 false
    }
    
    
    func hasCycle(_ head: ListNode?) -> Bool {
        guard head != nil, head?.next != nil else {
            return false
        }
        
        var slow = head
        var fast = head?.next
        
        while slow !== fast {
            if fast == nil, fast?.next == nil {
                return false
            }
            
            slow = slow?.next
            fast = fast?.next?.next
            
        }
        return true
    }
    
 

}
