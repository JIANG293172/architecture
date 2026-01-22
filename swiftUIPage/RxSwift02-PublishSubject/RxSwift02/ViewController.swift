//
//  ViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disposeBag = DisposeBag()
        
        // 只发送订阅后的智
        let publishSubject = PublishSubject<String>()
        publishSubject.onNext("这个不会被收到")
        publishSubject.subscribe { value in
            print("publishSbuject： \(value)")
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("World")
        
        /// BehaviorSubject 会发送最近的一个值和所有值
        let behaviorSubject = BehaviorSubject<String>(value: "初始值")
        
        behaviorSubject.subscribe { value in
            print("Behavior : \(value)")
        } onCompleted: {
            
        }.disposed(by: disposeBag)
        behaviorSubject.onNext("新值")
        
        
        /// ReplaySubject - 会重放制定数量的历史值
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.onNext("值1")
        replaySubject.onNext("值2")
        replaySubject.onNext("值3")
        
        replaySubject.subscribe { value in
            print("ReplaySubject: \(value)")
        } onCompleted: {
            
        }.disposed(by: disposeBag)
        
        
        
        

        
        

        
        
        // Do any additional setup after loading the view.
    }


}

