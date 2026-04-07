# 专利3：一种滑动自动吸顶的TabBar组件

## 技术领域
本发明涉及iOS导航组件技术领域，特别涉及一种可自动吸附在顶部的滑动TabBar组件。

## 背景技术
当页面有多个分类Tab时，用户滑动内容后希望Tab能自动吸顶锁定，但现有UITabBarController无法实现吸顶效果。

## 发明内容

### 核心实现
```swift
class StickyTabBarView: UIView {

    private var scrollView: UIScrollView!
    private var tabButtons: [UIButton] = []
    private var indicatorView: UIView!
    private var currentIndex = 0

    // 滑动阈值：超过50px自动吸顶
    private let stickyThreshold: CGFloat = 50

    func bind(to scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.delegate = self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        // 判断是否超过阈值，触发吸附
        if offsetY > stickyThreshold && !isSticky {
            snapToTop()
        } else if offsetY < stickyThreshold && isSticky {
            releaseFromTop()
        }
    }

    private func snapToTop() {
        // TabBar自动吸附到导航栏下方
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        isSticky = true
    }
}
```

## 优点
1. 智能判断吸附时机
2. 动画过渡平滑
3. 无需手动切换Tab

## 权利要求
1. 一种滑动自动吸顶的TabBar组件，其特征在于：监测滚动偏移量，超过阈值时自动吸附到顶部。
2. 根据权利要求1所述的组件，其特征在于：回滚时自动释放回到原位。
