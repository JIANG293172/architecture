//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

//cd /Users/taojiang/Desktop/poxiao/architecture/okx/SwiftDemo && xcodebuild -workspace SwiftDemo.xcworkspace -scheme SwiftDemo -configuration Debug -sdk iphoneos build
//xcodebuild -workspace SwiftDemo.xcworkspace -scheme SwiftDemo -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=18.6' build

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let demoList: [[String: String]] = [
        ["title": "Metal", "vcClassName": "MetalViewController"],
        ["title": "SecureEnclave", "vcClassName": "SecureEnclaveViewController"],
        ["title": "GCD", "vcClassName": "GCDViewController"],
        ["title": "续传", "vcClassName": "ResumeDownloadViewController"],
        ["title": "combine", "vcClassName": "CombineViewController"],
        ["title": "RXSwift", "vcClassName": "RXSwiftViewController"],
        ["title": "POP", "vcClassName": "POPViewController"],
        ["title": "设计模式", "vcClassName": "DesignPatternViewController"],
        ["title": "算法", "vcClassName": "AlgorithmListViewController"],
        ["title": "性能", "vcClassName": "PerformanceListViewController"],
        ["title": "网络", "vcClassName": "NetworkListViewController"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Demo 入口"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let demoItem = demoList[indexPath.row]
        cell.textLabel?.text = demoItem["title"]
        cell.textLabel?.textColor = .black
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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







