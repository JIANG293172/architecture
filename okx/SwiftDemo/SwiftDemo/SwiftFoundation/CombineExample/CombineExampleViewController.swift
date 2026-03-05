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

var cancellables = Set<AnyCancellable>()

class CombineExampleViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let example = Example26_Conbine()
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
            func setupPublisher() {
                let publiser = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                
                publiser
                    .sink {  time in
                        print("当前时间 \(time)")
                        if cancellables.count ?? 0 > 0,
                            time.timeIntervalSince1970 > (Date().timeIntervalSince1970 + 3 ) {
                            cancellables.removeAll()
                        }
                    }
                    .store(in: &cancellables)
            }
        }
        
        let vm = ViewModel()
        vm.setupPublisher()
        
        RunLoop.main.run(until: Date().addingTimeInterval(5)) // 运行5秒后退出
    }

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


class Example9_Combine {
    let numbers = [1 ,2 ,3 , 4, 5]
    func test() {
        
        let sequencePulisher = numbers.publisher
        sequencePulisher
            .sink { completion in
                print(completion)
            } receiveValue: { value in
                print(value)
            }
            .store(in: &cancellables)
    }
}



class Example10_Combine {
    func test() {
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        // 只取前3个值
        timerPublisher.prefix(3)
            .sink { time in
                print("value: \(time)")
            }
            .store(in: &cancellables)
        
    }
}

class Example11_Combine {
    func test() {
        [1, 2, 3, 4].publisher
            .map { $0 * 10 }
            .map { "转换后 \($0)" }
            .sink { value in
                print("打印： \(value)")
            }
            .store(in: &cancellables)
    }
}


class Example12_Combine {
    
    func test() {
        let values: [String?] = ["10", "20", nil, "30", "abc"]
        values.publisher
            .compactMap { value in
                value.flatMap{ Int($0) }
            }
            .sink { value in
                print("有效数字 \(value)")
            }
            .store(in: &cancellables)
    }
    
}


class Example13_Combine {
    
    func test() {
        [1, 2, 3].publisher
            .flatMap { value in
                self.fetchUser(id: value)
            }
            .sink { value in
                print("\(value)")
            }
            .store(in: &cancellables)
    }
    
    
    
    func fetchUser(id :Int) -> Future<String, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
                promise(.success("用户信息id\(id)的信息"))
            }
        }
    }
    
}

class Example14_Combine {
    
    func test() {
        (1...10).publisher
            .filter {
                $0 % 2 == 0
            }
            .sink { value in
                print("偶数 \(value)")
            }
            .store(in: &cancellables)
    }
}

class Example15_Cobine {
    
    func test() {
        (1...10).publisher
            .prefix(3)
            .sink {
                print("完成 \($0)")
            } receiveValue: {
                print("值: \($0)")
            }
            .store(in: &cancellables)
    }
    
}

//class Example16_Combine {
//    
//    func test() {
//        (1...10).publisher
//            .map { array in
//                array.suffix(3)
//            }
//            .sink {
//                print("\($0)")
//            }
//    }
//    
//}

class Example17_Combine {
    func test() {
        (1...10).publisher
            .dropFirst(5)
            .sink {
                print("\($0)")
            } receiveValue: {
                print("\($0)")
            }
    }
}

class Example18_Combine {
    
    func test() {
        (1...10).publisher
            .drop {
                $0 < 5
            }
            .sink {
                print($0)
            }
            .store(in: &cancellables)
    }
}

class Example19_Conbine {
    func test() {
        (1...10).publisher
            .first()
            .sink {
                print($0)
            }
            .store(in: &cancellables)
    }
}

class Example20_Conbine {
    func test() {
        (1...10).publisher
            .last()
            .sink {
                print($0)
            }
            .store(in: &cancellables)
    }
}

class Example21_Combine {
    func test() {
        
        let values: [String?] = ["A", nil, "B", nil, "C"]
        values.publisher
            .replaceNil(with: "默认值")
            .sink {
                print("替换后:\($0)")
            }
            .store(in: &cancellables)
    }
    
}


class Example22_Combine {
    
    func test() {
        let pub1 = PassthroughSubject<Int, Never>()
        let pub2 = PassthroughSubject<Int, Never>()
        Publishers.Merge(pub1, pub2)
            .sink {
                print("合并后的 \($0)")
            }
            .store(in: &cancellables)
        
        pub1.send(1)
        pub2.send(2)
        pub1.send(3)
        pub2.send(4)
        
    }
}

class Example23_Combine {
    
    func test() {
        let pub1 = ["A", "B", "C"].publisher
        let pub2 = ["1", "2", "3", "4"].publisher
        
        pub1.zip(pub2)
            .sink {
                print("拉链合并 \($0)")
            }
            .store(in: &cancellables)
        
        Publishers.Merge(pub1, pub2)
            .sink {
                print("合并 \($0)")
            }
            .store(in: &cancellables)
    }
}


class Example24_Combine {
    func test() {
        let username = PassthroughSubject<String, Never>()
        let password = PassthroughSubject<String, Never>()
        
        username.combineLatest(password)
            .sink {
                print("用户名： \($0). 密码：\($1)")
            }
            .store(in: &cancellables)
        
        username.send("user1")
        password.send("1234")
        
        username.send("user2")
        password.send("4321")
    }
}

class Example25_Combine {
    func test() {
        let searchTest = PassthroughSubject<String, Never>()
        
        searchTest
            .debounce(for: .seconds(1), scheduler: OperationQueue.main)
            .sink {
                print("搜索 \($0)")
            }
            .store(in: &cancellables)
        
        searchTest.send("s")
        searchTest.send("sw")
        searchTest.send("swi")
        searchTest.send("swift")
    }
}

class Example26_Conbine {
    
    func test() {
        let buttonTap = PassthroughSubject<Void, Never>()
        buttonTap.throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: true)
            .sink {
                print("点击")
            }
            .store(in: &cancellables)
        
        buttonTap.send()
        buttonTap.send()
        buttonTap.send()
        buttonTap.send()

    }
    
}


