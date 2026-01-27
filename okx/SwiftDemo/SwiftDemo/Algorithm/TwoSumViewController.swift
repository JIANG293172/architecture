import UIKit

class TwoSumViewController: UIViewController {
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Two Sum II"
        view.backgroundColor = .white
        setupUI()
        testTwoSum()
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
        explanationLabel.text = "Two Sum II Algorithm:\n\n1. Uses two-pointer technique for sorted arrays\n2. One pointer at the start, one at the end\n3. Adjust pointers based on sum comparison\n4. Time complexity: O(n)\n5. Space complexity: O(1)\n6. Efficient for sorted arrays"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    func testTwoSum() {
        let numbers = [2, 7, 11, 15]
        let target = 9
        let result = twoSum(numbers, target)
        
        let inputList = "Input: numbers = \(numbers), target = \(target)"
        let outputList = "Output: \(result)"
        
        textView.text = inputList + "\n" + outputList
    }
    
    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var left = 0
        var right = numbers.count - 1
        
        while left < right {
            let sum = numbers[left] + numbers[right]
            
            if sum == target {
                return [left + 1, right + 1] // Return 1-based indices
            } else if sum < target {
                left += 1
            } else {
                right -= 1
            }
        }
        
        return [] // No solution found
    }
}
