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
        
        testTwoSum()
    }

    // 两数之和 II（有序数组，返回下标+1，时间O(n)，空间O(1)）
    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var left = 0
        var right = numbers.count - 1
        
        while left < right {
            let sum = numbers[left] + numbers[right]
            if sum == target {
                return [left + 1, right + 1] // 题目要求下标从1开始
            } else if sum < target {
                left += 1 // 和太小，左指针右移
            } else {
                right -= 1 // 和太大，右指针左移
            }
        }
        return [] // 题目保证有解，此处仅为兜底
    }

    // 测试用例
    func testTwoSum() {
        let numbers = [2, 7, 11, 15]
        print(twoSum(numbers, 9)) // 输出 [1, 2]
        
        let numbers2 = [2, 3, 4]
        print(twoSum(numbers2, 6)) // 输出 [1, 3]
    }
   
}
