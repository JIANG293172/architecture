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

let disposeBag = DisposeBag()

class RXSwiftExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let example = Example19_RXSwift_Operator_Retry()
        example.test()
    }
    
}


class Example1_RXSwift_Basic_Obervale {
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

class Example2_RXSwift_Basic_Subject {
    
    func test() {
        let publish = PublishSubject<String>()
        publish.onNext("A")
        publish.subscribe {
            print("publish \($0)")
        } onCompleted: {
            print("completed")
        }.disposed(by: disposeBag)
        publish.onNext("B")

        
        let behavior = BehaviorSubject(value: "初始值")
        behavior.onNext("C")
        behavior.subscribe {
            print("behavior \($0)")
        }.disposed(by: disposeBag)
        behavior.onNext("D")
        
        
        let replay = ReplaySubject<Int>.create(bufferSize: 2)
        replay.onNext(1)
        replay.onNext(2)
        replay.onNext(3)
        
        replay.subscribe {
            print("replay \($0)")
        }.disposed(by: disposeBag)
    }
}


class Example3_RXSwift_Basic_Observer {

    func test() {
        let observer = AnyObserver<String> { event in
            switch event {
            case .next(let v):
                print("自定义观察 \(v)")
            case .error(let e):
                print("错误 \(e)")
            case .completed:
                print("完成")
            }
        }
        
        Observable.of("苹果", "香蕉").subscribe(observer).disposed(by: disposeBag)
    }
}

class Example4_RXSwift_Basic_DisposeBag {
    
    func test() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe {
                print("定时器 \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example5_RXSwift_Basic_Scheduler {
    
    func test() {
        Observable<Int>.create { obs in
            obs.onNext(1)
            obs.onCompleted()
            return Disposables.create()
        }
        .subscribe(on: MainScheduler.instance)
        .subscribe {
            print("主线程接受 \($0)")
        }
        .disposed(by: disposeBag)
    }
    
}


class Example6_RXSwift_Basic_Scheduler {
    func test() {
        Observable.of(1, 2 ,3)
            .map {
                $0 * 10
            }
            .subscribe {
                print("map: \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example7_RXSwift_Basic_Filter {
    func test() {
        
        Observable.of(1, 2, 3, 4, 5)
            .filter {
                $0 % 2 == 0
            }
            .subscribe {
                print("偶数 \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example8_RXSwift_Basic_CompactMap {
    
    func test() {
        Observable<String?>.of("1", "2", nil, "abc")
            .compactMap {
                $0.flatMap(Int.init)
            }
            .subscribe {
                print("compact \($0)")
            }
            .disposed(by: disposeBag)
    }
    
}


class Example9_RXSwift_Basic_FlatMap {
    
    func test() {
        let sub = BehaviorSubject(value: "A")
        let main = BehaviorSubject(value: sub)
        
        main.flatMap {
            $0
        }
        .subscribe {
            print("flat \($0)")
        }
        .disposed(by: disposeBag)
    }
}

class Example10_RXSwift_Basic_Operator_Take {
    func test() {
        Observable.of(1, 2, 3, 4, 5)
            .take(3)
            .subscribe {
                print("take \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example11_RXSwift_Operator_Zip {
    
    func test() {
        Observable.zip(Observable.of(1, 2), Observable.of("A", "B"))
            .subscribe {
                print("\($0), \($1)")
            }
            .disposed(by: disposeBag)
    }
}

class Example12_RXSwift_Operator_CombineLatest {
    
    func test() {
        let a = PublishSubject<Int>()
        let b = PublishSubject<String>()
        
        Observable.combineLatest(a, b)
            .subscribe {
                print("\($0) , \($1)")
            }
            .disposed(by: disposeBag)
        
        a.onNext(1)
        b.onNext("我们是")
    }
}

class example13_RXSwift_Operator_Merge {
    func test() {
        let a = PublishSubject<Int>()
        let b = PublishSubject<Int>()
        
        Observable.merge(a, b)
            .subscribe {
                print("\($0)")
            }
            .disposed(by: disposeBag)
        
        a.onNext(1)
        b.onNext(2)
    }
}

class Example14_RSSwift_Operator_Concat {
    
    func test() {
        
        Observable.concat(Observable.of(1, 2), Observable.of(3, 4))
            .subscribe {
                print("\($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example15_RXSwift_Operator_Debounce {
    
    func test() {
        let search = PublishSubject<String>()
        search.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe {
                print("\($0)")
            }
            .disposed(by: disposeBag)
        
        search.onNext("1")
        search.onNext("2")
        search.onNext("3")
        search.onNext("4")
        search.onNext("5")

    }
}

class Example16_RXSwift_Operator_Throttle {
    
    func test() {
        let tap = PublishSubject<Void>()
        tap.throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe {
                print("点击 \($0)")
            }
            .disposed(by: disposeBag)
        
        tap.onNext(Void())
        tap.onNext(Void())
        
        Thread.sleep(forTimeInterval: 3)
        tap.onNext(Void())
        tap.onNext(Void())
    }
}

class Example17_RXSwift_Operator_Reduce {
    
    func test() {
        Observable.of(1, 2, 3, 4, 5)
            .reduce(0, accumulator: +)
            .subscribe {
                print("\($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example18_RXSwift_Operator_Scan {
    func  test () {
        Observable.of(1, 2, 3, 4, 5)
            .scan(0, accumulator: +)
            .subscribe {
                print("scan: \($0)")
            }
            .disposed(by: disposeBag)
    }
}


class Example19_RXSwift_Operator_Retry {
    var count = 0
    
    func test() {
        Observable<Int>.create { [weak self] obs in
            print("==")
            
            self?.count += 1
            
            if self!.count < 3 {
                obs.onError(NSError(domain: "", code: 0))
            } else {
                obs.onNext(100)
                obs.onCompleted()
            }
            return Disposables.create()
        }
        .retry(2)
        .subscribe {
            print("成功, \($0)")
        }
        .disposed(by: disposeBag)
    }
}


class Example20_RXSwift_Operator_CatchError {
    
    func test() {
        
        Observable<Int>.error(NSError(domain: "", code: 0))
            .catch { _ in
                .just(0)
            }
            .subscribe {
                print(" ==== \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example21_RXSwift_UI_UITextField {
    
    let tf = UITextField()
    
    func test() {
        tf.rx.text.orEmpty
            .subscribe {
                print("输入 \($0)")
            }
            .disposed(by: disposeBag)
    }
    
}

class Example22_RXSwift_UI_Button {
    
    let btn = UIButton()
    
    func test() {
        btn.rx.tap
            .subscribe {
                print("点击了")
            }
            .disposed(by: disposeBag)
    }
}

class Example22_RXSwift_UI_TableView: UIViewController {
    
    let tv = UITableView()
    let  data = Observable.just(["苹果", "香蕉"])
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        data.bind(to: tv.rx.items(cellIdentifier: "cell")) { _,t,c in
            c.textLabel?.text = t
            
        }.disposed(by: disposeBag)
    }
}

class Example24_RXSwift_UI_CollectionView: UIViewController {
    
    let vc = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let data = Observable.just(["1", "2"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        data.bind(to: vc.rx.items(cellIdentifier: "cell")) { _,_,c in
            c.backgroundColor = .lightGray
            
        }
        .disposed(by: disposeBag)
    }
}


class Example25_RXSwift_UI_SegmentedControl {
    
    let seg = UISegmentedControl(items: ["首页", "我的"])
    
    func test() {
        seg.rx.selectedSegmentIndex
            .subscribe {
                print("选择 \($0)")
            }
            .disposed(by: disposeBag)
    }
}


class Example26_RXSwift_UI_Switch {
    
    
    let sw = UISwitch()
    
    func test() {
        
        sw.rx.isOn
            .subscribe {
                print("开关 \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example27_RXSwift_UI_Slider {
    
    let slider = UISlider()
    
    func test() {
        
        slider.rx.value
            .subscribe {
                print("值, \($0)")
            }
            .disposed(by: disposeBag)
    }
}

class Example28_RXSwift_UI_Alert: UIViewController {
    
    func test() {
        
        
        let btn = UIButton()
        btn.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<UIAlertAction> in
                let alert = UIAlertController(title: "提示", message: "", preferredStyle: .alert)
                alert.addAction(.init(title: "确定", style: .default))
                self?.present(alert, animated: true)
                return alert.rx.action
            }
            .subscribe {
                print("\($0)")
            }
            .disposed(by: disposeBag)
    }
    
    
}





