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
        testQuickSort()
        
    }
    
    // 快速排序（递归版，基准值选中间元素）
    func quickSort(_ nums: inout [Int], low: Int, high: Int) {
        guard low < high else { return }
        
        // 分区：返回基准值的最终位置
        let pivotIndex = partition(&nums, low: low, high: high)
        // 递归排序左半部分
        quickSort(&nums, low: low, high: pivotIndex - 1)
        // 递归排序右半部分
        quickSort(&nums, low: pivotIndex + 1, high: high)
    }

    // 分区函数（核心）
    private func partition(_ nums: inout [Int], low: Int, high: Int) -> Int {
        // 选中间元素作为基准（避免有序数组的最坏情况）
        let mid = low + (high - low) / 2
        nums.swapAt(mid, high) // 基准值移到末尾
        let pivot = nums[high]
        
        var i = low - 1 // 小于基准的区域边界
        for j in low..<high {
            if nums[j] <= pivot {
                i += 1
                nums.swapAt(i, j)
            }
        }
        // 基准值移到最终位置
        nums.swapAt(i + 1, high)
        return i + 1
    }

    // 测试用例
    func testQuickSort() {
        var nums = [5, 2, 9, 3, 7, 6, 1]
        quickSort(&nums, low: 0, high: nums.count - 1)
        print(nums) // 输出 [1, 2, 3, 5, 6, 7, 9]
    }
    
   
}
