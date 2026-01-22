//
//  ViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let dispostBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// operator
        
        let numbers = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
//        numbers.map{ $0 * 2 }
//            .subscribe {
//                print("print Map: \($0)")
//            }.disposed(by: dispostBag )
//        
//        numbers.filter { $0 % 2 == 0}
//            .subscribe {
//                print("Filter \($0)")
//            }.disposed(by: dispostBag)
        

        /// FlatMap 每个元素转换为新的 Obervable
//        let strings = Observable.of("A", "B", "C")
//        strings.flatMap { letter in
//            Observable.of("\(letter)1", "\(letter)2")
//        }
//        .subscribe {
//            print("FlatMap: \($0)")
//        }.disposed(by: dispostBag)
        
        
        let userName = Observable.of("user1", "user2")
        let password = Observable.of("pass1", "pass2")
        
        Observable.combineLatest(userName, password)
            .subscribe { user, pass in
                print("CombineLatest: \(user) - \(pass)")
            }
            .disposed(by: dispostBag)
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }


}

