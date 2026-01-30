import UIKit

/// 冒泡排序算法演示视图控制器
class BubbleSortViewController: UIViewController {
    
    /// 用于显示排序前后数组的文本视图
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bubble Sort"
        view.backgroundColor = .white
        setupUI()
        testBubbleSort()
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
        explanationLabel.text = "Bubble Sort Algorithm:\n\n1. Uses comparison-based sorting\n2. Repeatedly steps through the list, compares adjacent elements\n3. Swaps them if they are in the wrong order\n4. Time complexity: O(n²) in worst and average cases\n5. Space complexity: O(1)\n6. Simple to understand but inefficient for large datasets"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试冒泡排序算法
    func testBubbleSort() {
        // 定义一个测试数组
        let array = [5, 6, 2, 8, 3, 9, 3, 79, 3, 4]
        // 调用排序方法
        let sortedArray = sort(array: array)
        
        // 准备显示文本
        let originalList = "Original Array: \(array)"
        let sortedList = "\nSorted Array: \(sortedArray)"
        
        // 在文本视图中显示结果
        textView.text = originalList + sortedList
    }
    
    /// 冒泡排序算法实现
    /// - Parameter array: 需要排序的整数数组
    /// - Returns: 排序后的整数数组
    /// 思路：
    /// 1. 从数组的第一个元素开始，依次比较相邻的两个元素
    /// 2. 如果前一个元素大于后一个元素，就交换它们的位置
    /// 3. 每一轮比较结束后，最大的元素会"冒泡"到数组的末尾
    /// 4. 重复上述过程，直到整个数组排序完成
    func sort(array: [Int]) -> [Int] {
        // 如果数组长度小于等于1，直接返回
        guard array.count > 1 else {
            return array
        }
        
        // 创建一个可变数组用于排序
        var sortArray = array
        
        let n = array.count
        
        // 外层循环：控制排序轮数
        for i in 0..<n {
            // 内层循环：比较相邻元素并交换
            // 每一轮结束后，最大的i+1个元素已经排好序，不需要再比较
            for j in 0..<(n - i - 1) {
                // 如果前一个元素大于后一个元素，交换它们
                if sortArray[j] > sortArray[j+1] {
                    let temp = sortArray[j]
                    sortArray[j] = sortArray[j+1]
                    sortArray[j+1] = temp
                }
            }
        }
        
        return sortArray
    }
}
