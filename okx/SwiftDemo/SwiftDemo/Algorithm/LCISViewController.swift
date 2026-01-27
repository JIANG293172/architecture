import UIKit

class LCISViewController: UIViewController {
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Longest Continuous Increasing Subsequence"
        view.backgroundColor = .white
        setupUI()
        testFindLengthOfLCIS()
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
        explanationLabel.text = "LCIS Algorithm:\n\n1. Finds the longest consecutive increasing subsequence\n2. Uses a linear scan with two variables\n3. Time complexity: O(n), where n is the length of the array\n4. Space complexity: O(1), constant extra space"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
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
}
