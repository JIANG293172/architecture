import UIKit

class BubbleSortViewController: UIViewController {
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bubble Sort"
        view.backgroundColor = .white
        setupUI()
        testBubbleSort()
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
        explanationLabel.text = "Bubble Sort Algorithm:\n\n1. Uses comparison-based sorting\n2. Repeatedly steps through the list, compares adjacent elements\n3. Swaps them if they are in the wrong order\n4. Time complexity: O(n²) in worst and average cases\n5. Space complexity: O(1)\n6. Simple to understand but inefficient for large datasets"
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .gray
        view.addSubview(explanationLabel)
    }
    
    func testBubbleSort() {
        let array = [5, 6, 2, 8, 3, 9, 3, 79, 3, 4]
        let sortedArray = sonrt(array: array)
        
        let originalList = "Original Array: \(array)"
        let sortedList = "\nSorted Array: \(sortedArray)"
        
        textView.text = originalList + sortedList
    }
    
    func sonrt(array: [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        
        var sortArray = array
        
        let n = array.count
        
        for i in 0..<n {
            for j in 0..<(n - i - 1) {
                if sortArray[j] > sortArray[j+1] {
                    let maxNum = sortArray[j]
                    sortArray[j] = sortArray[j+1]
                    sortArray[j+1] = maxNum
                }
            }
        }
        
        return sortArray
    }
}
