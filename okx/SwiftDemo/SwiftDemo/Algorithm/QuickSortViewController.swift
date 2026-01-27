import UIKit

class QuickSortViewController: UIViewController {
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quick Sort"
        view.backgroundColor = .white
        setupUI()
        testQuickSort()
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
        explanationLabel.text = "Quick Sort Algorithm:\n\n1. Uses divide-and-conquer strategy\n2. Selects a pivot element and partitions the array\n3. Recursively sorts the sub-arrays\n4. Average time complexity: O(n log n)\n5. Worst case time complexity: O(n²) (rare with good pivot selection)\n6. Space complexity: O(log n) (due to recursion stack)"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    func testQuickSort() {
        var nums = [5, 2, 9, 3, 7, 6, 1]
        let originalNums = nums
        
        quickSort(&nums, low: 0, high: nums.count - 1)
        
        let originalList = "Original Array: \(originalNums)"
        let sortedList = "\nSorted Array: \(nums)"
        
        textView.text = originalList + sortedList
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
}
