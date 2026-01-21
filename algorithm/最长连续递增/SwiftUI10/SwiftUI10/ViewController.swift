//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testFindLengthOfLCIS()
    }

    // 最长连续递增序列（时间O(n)，空间O(1)）
    func findLengthOfLCIS(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        
        var maxLength = 1
        var currentLength = 1
        
        for i in 1..<nums.count {
            if nums[i] > nums[i-1] {
                currentLength += 1
                maxLength = max(maxLength, currentLength)
            } else {
                currentLength = 1 // 重置当前长度
            }
        }
        return maxLength
    }

    // 测试用例
    func testFindLengthOfLCIS() {
        let nums = [1,3,5,4,7]
        print(findLengthOfLCIS(nums)) // 输出 3（1,3,5）
        
        let nums2 = [2,2,2,2]
        print(findLengthOfLCIS(nums2)) // 输出 1
        
        let nums3 = [1,2,3,4]
        print(findLengthOfLCIS(nums3)) // 输出 4
    }
   
}
