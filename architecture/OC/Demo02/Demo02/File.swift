//
//  File.swift
//  Demo02
//
//  Created by CQCA202121101_2 on 2025/12/5.
//

import Foundation
import UIKit

class TestVC: UIViewController {
    var innerBlock1: (() -> Void)?
    var innerBlock2: (() -> Void)? // 被 self 持有（长期）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    var closureA: (() -> Void)?
    var closureB: (() -> Void)?
        
    func setup() {
        // 外层使用了 [weak self]
        closureA = { [weak self] in
            print("closureA")

            // 这里为了方便，把 weak self 变成了 strong self
            guard let self = self else { return }
            
            // ⚠️ 危险！
            // 这里的 closureB 捕获的是上面那个刚刚解包出来的 `strong` self
            // 导致：self -> closureA -> (strong self) -> closureB -> (strong self) -> 循环！
            self.closureB = {
                print("closureB")

                print(self.description)
            }
            
            if let b = self.closureB {
                b()
            }
        }
        if let a = closureA {
            a()
        }
        
    }
    
    
    deinit {
        print("deinit")
    }
}
