import UIKit

/// 两数之和II算法演示视图控制器
class TwoSumViewController: UIViewController {
    
    /// 用于显示测试结果的文本视图
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Two Sum II"
        view.backgroundColor = .white
        setupUI()
        testTwoSum()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置文本视图，用于显示测试结果
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
        explanationLabel.text = "Two Sum II Algorithm:\n\n1. Uses two-pointer technique for sorted arrays\n2. One pointer at the start, one at the end\n3. Adjust pointers based on sum comparison\n4. Time complexity: O(n)\n5. Space complexity: O(1)\n6. Efficient for sorted arrays"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试两数之和II算法
    /// 思路：
    /// 1. 定义测试用例
    /// 2. 调用算法函数
    /// 3. 显示测试结果
    func testTwoSum() {
        let numbers = [2, 7, 11, 15]
        let target = 9
        let result = twoSum(numbers, target)
        
        let inputList = "Input: numbers = \(numbers), target = \(target)"
        let outputList = "Output: \(result)"
        
        textView.text = inputList + "\n" + outputList
    }
    
    /// 两数之和II算法实现（针对有序数组）
    /// - Parameters:
    ///   - numbers: 已排序的整数数组
    ///   - target: 目标和
    /// - Returns: 两个数的索引（从1开始）
    /// 思路：使用双指针技术
    /// 1. 初始化左指针为0，右指针为数组末尾
    /// 2. 计算左右指针指向元素的和
    /// 3. 如果和等于目标值，返回两个指针的索引（加1，因为题目要求从1开始）
    /// 4. 如果和小于目标值，左指针右移（增加和）
    /// 5. 如果和大于目标值，右指针左移（减少和）
    /// 6. 重复上述过程，直到找到目标和或指针交叉
    /// 7. 时间复杂度：O(n)，空间复杂度：O(1)
    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        // 初始化左指针和右指针
        var left = 0
        var right = numbers.count - 1
        
        // 循环直到指针交叉
        while left < right {
            // 计算当前和
            let sum = numbers[left] + numbers[right]
            
            if sum == target {
                // 找到目标和，返回索引（从1开始）
                return [left + 1, right + 1]
            } else if sum < target {
                // 和小于目标值，左指针右移
                left += 1
            } else {
                // 和大于目标值，右指针左移
                right -= 1
            }
        }
        
        // 没有找到解决方案
        return []
    }
}
