//
//  ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let demoList: [[String: String]] = [
        ["title": "Metal", "vcClassName": "Demo1ViewController"],
        ["title": "SecureEnclave", "vcClassName": "Demo2ViewController"],
        ["title": "GCD", "vcClassName": "Demo3ViewController"],
        ["title": "续传", "vcClassName": "Demo4ViewController"],
        ["title": "combine", "vcClassName": "Demo5ViewController"],
        ["title": "RXSwift", "vcClassName": "Demo6ViewController"],
        ["title": "POP", "vcClassName": "Demo7ViewController"],
        ["title": "设计模式", "vcClassName": "Demo8ViewController"]
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







