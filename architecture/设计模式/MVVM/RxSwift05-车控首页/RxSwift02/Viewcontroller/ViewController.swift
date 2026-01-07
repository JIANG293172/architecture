//
//  ViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit


// Controllers/HomeViewController.swift
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FSPagerView

class ViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var headerView: CarStatusHeaderView = {
        let view = CarStatusHeaderView()
        return view
    }()
    
    private let sectionTitles = ["基础远控", "空调控制", "车辆信息", "辅助驾驶", "用车服务"]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FunctionCell.self, forCellWithReuseIdentifier: FunctionCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var bannerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 120)
        pagerView.interitemSpacing = 16
        pagerView.backgroundColor = .clear
        return pagerView
    }()
    
    private let bannerPageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.contentHorizontalAlignment = .center
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return pageControl
    }()
    
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Subjects
    private let functionTappedSubject = PublishSubject<ControlFunction>()
    private let bannerTappedSubject = PublishSubject<Banner>()
    
    // MARK: - Initialization
//    init(viewModel: HomeViewModel = HomeViewModel()) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupLoadingView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // 添加头部视图
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        // 添加功能集合视图
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400) // 根据内容动态调整
        }
        
        // 添加轮播图
        contentView.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        // 添加轮播图指示器
        contentView.addSubview(bannerPageControl)
        bannerPageControl.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        scrollView.refreshControl = refreshControl
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "车控"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // 左侧菜单按钮
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        // 右侧切换车辆按钮
        let switchCarButton = UIBarButtonItem(
            image: UIImage(systemName: "car.2"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = switchCarButton
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        bannerView.dataSource = self
        bannerView.delegate = self
        
        let input = HomeViewModel.Input(
            viewDidLoad: Observable.just(()),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            functionTapped: functionTappedSubject.asObservable(),
            bannerTapped: bannerTappedSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        bindCarStatus(output: output)
        bindFunctions(output: output)
        bindBanners(output: output)
        bindLoadingState(output: output)
        bindErrors(output: output)
        bindNavigation(output: output)
    }
    
    private func bindCarStatus(output: HomeViewModel.Output) {
        output.carStatus
            .drive(onNext: { [weak self] status in
                if let status = status {
                    self?.headerView.configure(with: status)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFunctions(output: HomeViewModel.Output) {
        output.functions
            .drive(collectionView.rx.items(cellIdentifier: FunctionCell.reuseIdentifier, cellType: FunctionCell.self)) { index, function, cell in
                cell.configure(with: function)
            }
            .disposed(by: disposeBag)
        
        // 功能点击
        collectionView.rx.modelSelected(ControlFunction.self)
            .bind(to: functionTappedSubject)
            .disposed(by: disposeBag)
        
        // 动态调整集合视图高度
        output.functions
            .drive(onNext: { [weak self] functions in
                self?.updateCollectionViewHeight(functions: functions)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBanners(output: HomeViewModel.Output) {
        output.banners
            .drive(onNext: { [weak self] banners in
                self?.bannerPageControl.numberOfPages = banners.count
                self?.bannerView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingState(output: HomeViewModel.Output) {
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindErrors(output: HomeViewModel.Output) {
        output.error
            .drive(onNext: { [weak self] errorMessage in
                if !errorMessage.isEmpty {
                    self?.showErrorAlert(message: errorMessage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(output: HomeViewModel.Output) {
        output.selectedFunction
            .drive(onNext: { [weak self] function in
                self?.handleFunctionTap(function)
            })
            .disposed(by: disposeBag)
        
        output.selectedBanner
            .drive(onNext: { [weak self] banner in
                self?.handleBannerTap(banner)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Updates
    private func updateCollectionViewHeight(functions: [ControlFunction]) {
        let rows = ceil(Double(functions.count) / 4.0) // 每行4个
        let height = rows * 80 + (rows - 1) * 12 + 24 // 计算总高度
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    // MARK: - Handlers
    private func handleFunctionTap(_ function: ControlFunction) {
        switch function.type {
        case .airConditioner:
            showACControl()
        case .quickCool:
            toggleQuickCool()
        case .digitalKey:
            showDigitalKey()
        case .assistedDriving:
            showAssistedDriving()
        case .safetyService:
            showSafetyService()
        case .vehicleService:
            showVehicleService()
        case .moreService:
            showMoreService()
        default:
            break
        }
    }
    
    private func handleBannerTap(_ banner: Banner) {
        let alert = UIAlertController(
            title: "打开链接",
            message: "是否打开：\(banner.title)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "打开", style: .default) { _ in
            // 实际项目中这里会打开网页
            print("打开链接: \(banner.linkUrl ?? "")")
        })
        present(alert, animated: true)
    }
    
    private func showACControl() {
        let acVC = ACControlViewController()
        navigationController?.pushViewController(acVC, animated: true)
    }
    
    private func toggleQuickCool() {
        // 实现速冷模式切换
        print("切换速冷模式")
    }
    
    private func showDigitalKey() {
        // 显示数字钥匙界面
        print("显示数字钥匙")
    }
    
    private func showAssistedDriving() {
        // 显示辅助驾驶界面
        print("显示辅助驾驶")
    }
    
    private func showSafetyService() {
        // 显示安全服务界面
        print("显示安全服务")
    }
    
    private func showVehicleService() {
        // 显示用车服务界面
        print("显示用车服务")
    }
    
    private func showMoreService() {
        // 显示更多服务界面
        print("显示更多服务")
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - FSPagerView DataSource & Delegate
extension ViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3 // 实际从banners数据获取
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, at: index) as? BannerCell else {
            return FSPagerViewCell()
        }
        
        // 这里应该使用实际的banner数据
        let banner = Banner(
            id: "\(index)",
            imageUrl: "https://picsum.photos/400/200?random=\(index + 1)",
            title: "长安汽车 - 广告 \(index + 1)",
            linkUrl: nil
        )
        cell.configure(with: banner)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let banner = Banner(
            id: "\(index)",
            imageUrl: "https://picsum.photos/400/200?random=\(index + 1)",
            title: "长安汽车 - 广告 \(index + 1)",
            linkUrl: "https://changan.com/banner\(index)"
        )
        bannerTappedSubject.onNext(banner)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        bannerPageControl.currentPage = pagerView.currentIndex
    }
}

// 空调控制页面示例
class ACControlViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "空调控制"
        
        let label = UILabel()
        label.text = "空调控制界面"
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
