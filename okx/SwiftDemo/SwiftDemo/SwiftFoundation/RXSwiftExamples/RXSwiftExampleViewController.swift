//
//  RXSwiftExampleViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/5.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RXSwiftExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let example = Example1_RXSwift_Basic_Obervale()
        example.test()
    }
    
}


class Example1_RXSwift_Basic_Obervale {
    let disposeBag = DisposeBag()
    
    func test() {
        let observable = Observable<Int>.just(1)
        observable.subscribe { value in
            print("just1: \(value)")
        } onCompleted: {
            print("完成1")
        }.disposed(by: disposeBag)
        
        Observable.of(1, 2, 3)
            .subscribe {
                print("of2: \($0)")
            }
            .disposed(by: disposeBag)
        
        Observable<Void>.empty()
            .subscribe {
                print("完成3")
            }.disposed(by: disposeBag)
    }
    
    
    
}
