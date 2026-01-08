//
//  ViewController.swift
//  SwiftUIDemo
//
//  Created by CQCA202121101_2 on 2025/9/16.
//

import UIKit
import SwiftUI

struct MySwiftUIView: View {
    var message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(message).font(.title).padding(.top, 200).padding(.bottom, 300).frame(width: 20)
            Button("点击我") {
                print("SwiftUI 按钮被点击")
            }
            Text("增加一个").font(.title2)
            .buttonStyle(.borderedProminent)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftUIView = MySwiftUIView(message: "从 UIViewController 嵌入")
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        hostingController.view.frame = CGRectMake(50, 100, view.bounds.width - 100, 200)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        
        // Do any additional setup after loading the view.
    }


}

