import UIKit

/// 最长连续递增子序列算法演示视图控制器
class LCISViewController: UIViewController {
    
    /// 用于显示测试结果的文本视图
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Longest Continuous Increasing Subsequence"
        view.backgroundColor = .white
        setupUI()
        testFindLengthOfLCIS()
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
        explanationLabel.text = "LCIS Algorithm:\n\n1. Finds the longest consecutive increasing subsequence\n2. Uses a linear scan with two variables\n3. Time complexity: O(n), where n is the length of the array\n4. Space complexity: O(1), constant extra space"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    /// 测试最长连续递增子序列算法
    /// 思路：
    /// 1. 定义多个测试用例，覆盖不同场景
    /// 2. 对每个测试用例调用算法函数
    /// 3. 收集并显示测试结果
    func testFindLengthOfLCIS() {
        let testCases = [
            [1, 3, 5, 4, 7],  // Expected: 3 (1,3,5)
            [2, 2, 2, 2],     // Expected: 1
            [1, 2, 3, 4]      // Expected: 4
        ]
        
        var resultText = ""
        for (index, nums) in testCases.enumerated() {
            let length = findLengthOfLCIS(nums)
            resultText += "Test Case \(index + 1): \(nums)\n"
            resultText += "Longest Continuous Increasing Subsequence Length: \(length)\n\n"
        }
        
        textView.text = resultText
    }
    
    /// 最长连续递增子序列算法实现
    /// - Parameter nums: 输入整数数组
    /// - Returns: 最长连续递增子序列的长度
    /// 思路：
    /// 1. 使用一次线性扫描，维护两个变量：maxLength（最大长度）和currentLength（当前长度）
    /// 2. 从数组的第二个元素开始，依次比较相邻元素
    /// 3. 如果当前元素大于前一个元素，currentLength加1，并更新maxLength
    /// 4. 否则，重置currentLength为1
    /// 5. 时间复杂度：O(n)，空间复杂度：O(1)
    func findLengthOfLCIS(_ nums: [Int]) -> Int {
        // 如果数组为空，返回0
        guard !nums.isEmpty else { return 0 }
        
        // 初始化最大长度和当前长度为1
        var maxLength = 1
        var currentLength = 1
        
        // 从第二个元素开始遍历数组
        for i in 1..<nums.count {
            // 如果当前元素大于前一个元素，说明序列在递增
            if nums[i] > nums[i-1] {
                // 当前长度加1
                currentLength += 1
                // 更新最大长度
                maxLength = max(maxLength, currentLength)
            } else {
                // 序列不再递增，重置当前长度为1
                currentLength = 1
            }
        }
        // 返回最大长度
        return maxLength
    }
}
