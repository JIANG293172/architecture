//
//  Demo8ViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

class DesignPatternViewController: ViewController {
    
    // Override demoList to define custom view controllers for design patterns
    private let demoList: [[String: String]] = [
        ["title": "Singleton Pattern", "vcClassName": "SingletonPatternViewController"],
        ["title": "Factory Pattern", "vcClassName": "FactoryPatternViewController"],
        ["title": "Decorator Pattern", "vcClassName": "DecoratorPatternViewController"],
        ["title": "Strategy Pattern", "vcClassName": "StrategyPatternViewController"],
        ["title": "Adapter Pattern", "vcClassName": "AdapterPatternViewController"],
        ["title": "Observer Pattern", "vcClassName": "ObserverPatternViewController"],
        ["title": "Facade Pattern", "vcClassName": "FacadePatternViewController"],
        ["title": "Coordinator Pattern", "vcClassName": "CoordinatorDemoViewController"],
        ["title": "VIPER Architecture", "vcClassName": "VIPERDemoViewController"],
        ["title": "MVP Architecture", "vcClassName": "MVPDemoViewController"],
        ["title": "MVVM Combine Architecture", "vcClassName": "MVVMDemoViewController"],
        ["title": "MVVM RxSwift Architecture", "vcClassName": "RxMVVMDemoViewController"],
        ["title": "Combine DataBus (Local Pod)", "vcClassName": "DataBusDemoViewController"],
        ["title": "RxSwift DataBus (Local Pod)", "vcClassName": "RxDataBusDemoViewController"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Design Patterns"
    }
    
    // Override table view data source methods to use custom demoList
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let demoItem = demoList[indexPath.row]
        cell.textLabel?.text = demoItem["title"]
        cell.textLabel?.textColor = .black
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    // Override didSelectRowAt to use custom demoList
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let demoItem = demoList[indexPath.row]
        guard let vcClassName = demoItem["vcClassName"] else {
            return
        }
        
        // Use runtime to create view controller from class name
        if let vcClass = NSClassFromString("SwiftDemo." + vcClassName) as? UIViewController.Type {
            let targetVC = vcClass.init()
            navigationController?.pushViewController(targetVC, animated: true)
        }
    }
}

