# 专利15：一种车辆小蛮腰加载动画组件

## 技术领域
本发明涉及iOS加载动画技术领域，特别涉及一种品牌化的车辆轮廓加载动画组件。

## 背景技术
APP加载时需要等待，现有loading动画通用且缺乏品牌识别度。

## 发明内容

### 核心实现
```swift
class VehicleLoadingView: UIView {

    private let carPathLayer = CAShapeLayer()
    private let tireLayer1 = CAShapeLayer()
    private let tireLayer2 = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    private func setupLayers() {
        // 绘制车身边框（小蛮腰造型）
        let carPath = UIBezierPath()
        carPath.move(to: CGPoint(x: 20, y: 40))
        carPath.addLine(to: CGPoint(x: 35, y: 35))   // 引擎盖
        carPath.addLine(to: CGPoint(x: 45, y: 25))   // 车顶（凹起）
        carPath.addLine(to: CGPoint(x: 75, y: 25))   // 车顶
        carPath.addLine(to: CGPoint(x: 85, y: 35))   // 车尾
        carPath.addLine(to: CGPoint(x: 100, y: 40))  // 车尾底部

        carPathLayer.path = carPath.cgPath
        carPathLayer.strokeColor = UIColor.systemBlue.cgColor
        carPathLayer.fillColor = UIColor.clear.cgColor
        carPathLayer.lineWidth = 3
        carPathLayer.lineCap = .round
        layer.addSublayer(carPathLayer)

        // 左轮胎
        let tire1 = CAShapeLayer()
        tire1.path = UIBezierPath(ovalIn: CGRect(x: 25, y: 38, width: 8, height: 8)).cgPath
        tire1.fillColor = UIColor.darkGray.cgColor
        layer.addSublayer(tire1)

        // 右轮胎
        let tire2 = CAShapeLayer()
        tire2.path = UIBezierPath(ovalIn: CGRect(x: 87, y: 38, width: 8, height: 8)).cgPath
        tire2.fillColor = UIColor.darkGray.cgColor
        layer.addSublayer(tire2)
    }

    func startAnimating() {
        // 路径动画：虚线流动效果
        let dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.fromValue = 0
        dashAnimation.toValue = 20
        dashAnimation.duration = 0.5
        dashAnimation.repeatCount = .infinity
        carPathLayer.add(dashAnimation, forKey: "dash")

        // 轮胎旋转
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        tireLayer1.add(rotation, forKey: "rotate")
        tireLayer2.add(rotation, forKey: "rotate")
    }
}
```

## 优点
1. 品牌化设计，增强识别度
2. 加载状态清晰
3. 轻量级实现

## 权利要求
1. 一种车辆小蛮腰加载动画组件，其特征在于：使用CAShapeLayer绘制车辆轮廓路径，采用虚线流动动画表示加载状态。
2. 根据权利要求1所述的组件，其特征在于：轮胎同步旋转，增强动态效果。
