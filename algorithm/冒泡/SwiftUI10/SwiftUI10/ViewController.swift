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
        
        print(self.sonrt(array: [5,6,2,8,3,9,3,79,3,4]))
        
    }
    
    
    
    func sonrt(array: [Int]) -> [Int] {
        guard  array.count > 1 else {
            return array
        }
        
        var sortArray = array
        
        let n  = array.count
        
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
