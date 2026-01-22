//
//  Demo3ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2026/1/22.
//

import UIKit

// Demo 3 ViewController
class Demo3ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo 3: 网络请求示例"
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "这是网络请求示例"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
    }
    
    
    
}


