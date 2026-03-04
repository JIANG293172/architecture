//
//  CombineExampleViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import Foundation
import UIKit
import Combine

enum ExampleNetworkError: Error {
    case invalidURL
    case requestFailed
}

class CombineExampleViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let example = Example8_Combine()
        example.test()
    }
    
    func example1() {
        let justPublisher = Just("hello combine!")
        
        let cancellable = justPublisher
            .sink { completion in
                print("完成状态： \(completion)")
            } receiveValue: { value in
                print("收到值 \(value)")
            }
    }
    
    
    func example2() {
        let counter = CurrentValueSubject<Int, Never>(0)
        
        let cancellable = counter
            .sink { value in
                print("当前计数： \(value)")
            }
        counter.send(0)
        counter.send(1)
        counter.send(2)
        counter.send(3)
    }
    
    func example3() {
        let messageSubject = PassthroughSubject<String, Never>()
        
        let cancellable = messageSubject
            .sink { completion in
                print("消息发送完成")
            } receiveValue: { value in
                print("收到消息 \(value)")
            }
    }
    

    
    func example4() {
        

        
        let networkSubject = PassthroughSubject<Data, ExampleNetworkError>()
        let cancellable = networkSubject
            .sink { completion in
                switch completion {
                case .finished:
                    print("请求完成")
                case .failure(let error):
                    print("请求失败 \(error)")
                }
                
            } receiveValue: { value in
                print("收到数据 \(value.count)")
            }
        
        
        networkSubject.send(Data([1, 2 ,3]))
        networkSubject.send(completion: .failure(.requestFailed))
        
    }
    

    
    func example5() {
        class ViewModel {
            private var cancellables = Set<AnyCancellable>()
            
            func setupPublisher() {
                let publiser = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                
                publiser
                    .sink { [weak self] time in
                        print("当前时间 \(time)")
                        if self?.cancellables.count ?? 0 > 0,
                            time.timeIntervalSince1970 > (Date().timeIntervalSince1970 + 3 ) {
                            self?.cancellables.removeAll()
                        }
                    }
                    .store(in: &cancellables)
            }
        }
        
        let vm = ViewModel()
        vm.setupPublisher()
        
        RunLoop.main.run(until: Date().addingTimeInterval(5)) // 运行5秒后退出
    }
    private var cancellables = Set<AnyCancellable>()

    
    func example6() {
        let emptyFinished = Empty<Int, Never>()
        emptyFinished.sink { completion in
            print("")
        } receiveValue: { value in
            print("\(value)")
        }.store(in: &cancellables)
        
        
        let emptyFailure = Empty<Int, ExampleNetworkError>(completeImmediately: true)
        
        emptyFailure.sink { completion in
            print("")
        } receiveValue: { value in
            print("")
        }.store(in: &cancellables)
   
    }
}


class Example7_Combine {
    private var cancellables = Set<AnyCancellable>()

    func fetchData() -> Future<String, ExampleNetworkError> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                
                promise(.success("异步获取数据"))
            }
        }
    }
    
    func test() {
        
        fetchData().sink { completion in
            print("请求完成")
        } receiveValue: { value in
            print("收到数据\(value)")
        }.store(in: &cancellables)

    }
    
}


class Example8_Combine {
    private var cancellables = Set<AnyCancellable>()

 
    func test() {
        
        let deferredPubliser = Deferred {
            print("发布者被创建")
            return Just("deferred value")
        }
        
        print("准备订阅")
        
        deferredPubliser
            .sink { value in
                print("收到 \(value)")
            }
            .store(in: &cancellables)
    }
}
