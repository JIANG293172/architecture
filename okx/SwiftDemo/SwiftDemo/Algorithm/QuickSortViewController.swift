import UIKit

/// 快速排序算法演示视图控制器
class QuickSortViewController: UIViewController {
    
    /// 用于显示排序前后数组的文本视图
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quick Sort"
        view.backgroundColor = .white
        setupUI()
        testQuickSort()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置文本视图，用于显示排序结果
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
        explanationLabel.text = "Quick Sort Algorithm:\n\n1. Uses divide-and-conquer strategy\n2. Selects a pivot element and partitions the array\n3. Recursively sorts the sub-arrays\n4. Average time complexity: O(n log n)\n5. Worst case time complexity: O(n²) (rare with good pivot selection)\n6. Space complexity: O(log n) (due to recursion stack)"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试快速排序算法
    func testQuickSort() {
        // 定义一个测试数组
        var nums = [5, 2, 9, 3, 7, 6, 1]
        // 保存原始数组用于显示
        let originalNums = nums
        
        // 调用快速排序方法
        quickSort(&nums, low: 0, high: nums.count - 1)
        
        // 准备显示文本
        let originalList = "Original Array: \(originalNums)"
        let sortedList = "\nSorted Array: \(nums)"
        
        // 在文本视图中显示结果
        textView.text = originalList + sortedList
    }
    
    /// 快速排序算法实现（递归版）
    /// - Parameters:
    ///   - nums: 需要排序的整数数组（inout 表示可以修改原数组）
    ///   - low: 当前排序范围的起始索引
    ///   - high: 当前排序范围的结束索引
    /// 思路：
    /// 1. 选择一个基准值（pivot）
    /// 2. 将数组分区，使得基准值左边的元素都小于等于基准值，右边的元素都大于基准值
    /// 3. 递归地对左右两个子数组进行排序
    func quickSort(_ nums: inout [Int], low: Int, high: Int) {
        // 递归终止条件：如果起始索引大于等于结束索引，说明数组已经有序
        guard low < high else { return }
        
        // 分区操作：返回基准值的最终位置
        let pivotIndex = partition(&nums, low: low, high: high)
        
        // 递归排序左半部分（基准值左边的元素）
        quickSort(&nums, low: low, high: pivotIndex - 1)
        
        // 递归排序右半部分（基准值右边的元素）
        quickSort(&nums, low: pivotIndex + 1, high: high)
    }

    /// 分区函数（快速排序的核心）
    /// - Parameters:
    ///   - nums: 需要分区的整数数组
    ///   - low: 分区范围的起始索引
    ///   - high: 分区范围的结束索引
    /// - Returns: 基准值的最终位置
    /// 思路：
    /// 1. 选择一个基准值（这里选择中间元素，以避免有序数组的最坏情况）
    /// 2. 将基准值移到数组末尾
    /// 3. 遍历数组，将小于等于基准值的元素移到数组左侧
    /// 4. 将基准值移到最终位置（左侧都是小于等于它的元素，右侧都是大于它的元素）
    private func partition(_ nums: inout [Int], low: Int, high: Int) -> Int {
        // 选择中间元素作为基准值，避免有序数组的最坏情况
        let mid = low + (high - low) / 2
        // 将基准值移到数组末尾，方便后续处理
        nums.swapAt(mid, high)
        // 获取基准值
        let pivot = nums[high]
        
        // i 表示小于基准值的区域边界（初始为 -1）
        var i = low - 1
        
        // 遍历数组，将小于等于基准值的元素移到左侧
        for j in low..<high {
            if nums[j] <= pivot {
                // 扩大小于基准值的区域
                i += 1
                // 交换元素
                nums.swapAt(i, j)
            }
        }
        
        // 将基准值移到最终位置
        nums.swapAt(i + 1, high)
        
        // 返回基准值的最终位置
        return i + 1
    }
}
