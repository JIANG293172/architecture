//
//  NetworkListViewController.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/1/28.
//

import UIKit

/// 网络列表视图控制器，展示各种网络相关演示
class NetworkListViewController: ViewController {
    
    /// 网络演示列表，包含演示标题和对应的视图控制器类名
    /// 思路：使用字典数组存储网络演示信息，便于动态创建对应的演示页面
    private let demoList: [[String: String]] = [
        ["title": "PropertyWrapper", "vcClassName": "PropertyWrapperViewController"],
        ["title": "ProtocolBuffer", "vcClassName": "ProtocolBufferViewController"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Network"
    }
    
    /// 重写 tableView 数据源方法，返回网络演示列表的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    /// 重写 tableView 数据源方法，为每个网络演示创建对应的单元格
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
    
    /// 重写 tableView 代理方法，处理单元格点击事件
    /// 思路：使用运行时反射机制，根据存储的类名动态创建对应的视图控制器
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let demoItem = demoList[indexPath.row]
        guard let vcClassName = demoItem["vcClassName"] else {
            return
        }
        
        // 使用运行时反射机制，根据类名字符串创建对应的视图控制器实例
        // 格式："SwiftDemo." + 类名，确保能够正确找到类
        if let vcClass = NSClassFromString("SwiftDemo." + vcClassName) as? UIViewController.Type {
            let targetVC = vcClass.init()
            navigationController?.pushViewController(targetVC, animated: true)
        }
    }
}
