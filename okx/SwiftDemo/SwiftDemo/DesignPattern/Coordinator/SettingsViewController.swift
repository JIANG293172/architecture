//
//  SettingsViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/27.
//

import UIKit

/// 设置页面视图控制器
class SettingsViewController: UIViewController {
    /// 协调器
    weak var coordinator: MainCoordinator?
    
    private let tableView = UITableView()
    private let settingsItems = [
        SettingItem(title: "Account", icon: "person.fill"),
        SettingItem(title: "Notifications", icon: "bell.fill"),
        SettingItem(title: "Privacy", icon: "lock.fill"),
        SettingItem(title: "About", icon: "info.circle.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        view.addSubview(tableView)
    }
}

/// 设置项模型
struct SettingItem {
    let title: String
    let icon: String
}

/// 设置页面视图控制器扩展，实现表格视图代理和数据源方法
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        let settingItem = settingsItems[indexPath.row]
        cell.textLabel?.text = settingItem.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 这里可以根据设置项类型，通过协调器导航到不同的页面
        let settingItem = settingsItems[indexPath.row]
        print("Selected setting: \(settingItem.title)")
    }
}
