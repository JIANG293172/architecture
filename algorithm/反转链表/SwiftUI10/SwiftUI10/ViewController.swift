//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit

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
        
        let head = ListNode(1)
        head.next = ListNode(2)
        head.next?.next = ListNode(3)
        head.next?.next?.next = ListNode(4)
        head.next?.next?.next?.next = ListNode(5)
        
        var currentNode = self.reverseList(head)
        
        while currentNode != nil {
            print(currentNode!.val, terminator: " ")
            currentNode = currentNode?.next
        }
        
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
