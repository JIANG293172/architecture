//
//  ViewController.swift
//  RxSwift01
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ofObservable = Observable.of(1, 2, 3, 4, 5)
//        
//        ofObservable.subscribe { value in
//            print("of 收到 \(value)")
//        } onCompleted: {
//            print("完成")
//        }.disposed(by: disposeBag)
//        
//        let fromObservable = Observable.from([1, 2, 3, 4, 5])
//        fromObservable.subscribe { value in
//            print("from - 收到 \(value)")
//        } onError: { error in
//            
//        }.disposed(by: disposeBag)

        // Do any additional setup after loading the view.
        
        
        createCountdownObservable()
            .subscribe { value in
                print("当前倒计时： \(value)")
            } onError: { error in
                print("发生错误: \(error.localizedDescription)")
            } onCompleted: {
                print("倒计时完成!")
            } onDisposed: {
                print("订阅已销毁")
            }.disposed(by: disposeBag)

    }
    
    func createCountdownObservable() -> Observable<Int> {
        return Observable.create { observer in
            var count = 3
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if count > 0 {
                    observer.onNext(count)
                    count -= 1
                } else {
                    observer.onCompleted()
                    timer.invalidate()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            }
            
            return Disposables.create {
                timer.invalidate()
            }
        }
    }


}

