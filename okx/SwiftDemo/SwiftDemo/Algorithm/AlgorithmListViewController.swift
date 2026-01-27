import UIKit

/// 算法列表视图控制器，展示各种算法演示
class AlgorithmListViewController: ViewController {
    
    /// 算法演示列表，包含算法标题和对应的视图控制器类名
    /// 思路：使用字典数组存储算法信息，便于动态创建对应的演示页面
    private let demoList: [[String: String]] = [
        ["title": "Binary Tree Level Order Traversal", "vcClassName": "LevelOrderTraversalViewController"],
        ["title": "Binary Tree Max Depth", "vcClassName": "MaxDepthViewController"],
        ["title": "Reverse Linked List", "vcClassName": "ReverseListViewController"],
        ["title": "Quick Sort", "vcClassName": "QuickSortViewController"],
        ["title": "Longest Continuous Increasing Subsequence", "vcClassName": "LCISViewController"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Algorithms"
    }
    
    /// 重写 tableView 数据源方法，返回算法演示列表的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoList.count
    }
    
    /// 重写 tableView 数据源方法，为每个算法创建对应的单元格
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
