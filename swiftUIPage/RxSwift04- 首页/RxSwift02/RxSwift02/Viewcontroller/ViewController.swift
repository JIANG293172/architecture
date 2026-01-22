//
//  ViewController.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/5.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let loadingView = UIActivityIndicatorView(style: .large)
    private let favoriteTappedRelay = PublishRelay<Int>()
    private let profileTappedRelay = PublishRelay<Void>()
    private let headerHeight: CGFloat = 120
    private let headerContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeaderViewHeight()
    }
    
    private func setupUI() {
        title = "列表"
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupLoadingView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.refreshControl = refreshControl
        setupTableHeaderView()
    }
    
    private func setupTableHeaderView() {
        headerContainerView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerContainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
        tableView.tableHeaderView = headerContainerView
    }
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.hidesWhenStopped = true
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        headView.profileTapped
            .bind(to: profileTappedRelay)
            .disposed(by: disposeBag)
        
        let productSelected = tableView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .asObservable()
        
        let input = HomeViewModel.Input(
            viewDidLoad: Observable.just(()),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            productSeleted: productSelected,
            favoriteTapped: favoriteTappedRelay.asObservable(),
            profileTapped: profileTappedRelay.asObservable())
        
        let output = viewModel.transForm(input: input)
        
        bindUserInfo(output: output)
        bindProducts(output: output)
        bindLoadingState(output: output)
        bindErrors(outpu: output)
        bindNavigation(output: output)
    }
    
    private func bindUserInfo(output: HomeViewModel.Output) {
        output.user.drive { [weak self] user in
            if let user = user {
                self?.headView.configure(with: user)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindProducts(output: HomeViewModel.Output) {
        output.products
            .drive(tableView.rx.items(cellIdentifier: ProductCell.identifier, cellType: ProductCell.self)) { [weak self] _, product, cell in
                cell.configure(with: product)
                cell.favoriteTapped = {
                    self?.favoriteTappedRelay.accept(product.id)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindLoadingState(output: HomeViewModel.Output) {
        output.isLoading
             .drive(onNext: { [weak self] isLoading in
                 isLoading ? self?.loadingView.startAnimating() : self?.loadingView.stopAnimating()
                 if !isLoading {
                     self?.refreshControl.endRefreshing()
                 }
             })
             .disposed(by: disposeBag)
    }
    
    private func bindErrors(outpu: HomeViewModel.Output) {
        outpu.error
            .drive(onNext: { [weak self] errorMessage in
            if !errorMessage.isEmpty {
                self?.showErrorAlert(message: errorMessage)
            }
        })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(output: HomeViewModel.Output) {
        output.selectedProduct
            .drive(onNext: { [weak self] product in
                self?.navigateToProductDetail(product: product)
            })
            .disposed(by: disposeBag)
        
        output.navigateToProfile
            .drive(onNext: { [weak self] in
                self?.navigateToProfile()
            })
            .disposed(by: disposeBag)

    }
    
    private func navigateToProductDetail(product: Product) {
        let detailVC = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    
    private func navigateToProfile() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
        
    }

    private func updateTableHeaderViewHeight() {
        guard let headerView = tableView.tableHeaderView else { return }
        headerView.frame.size.width = tableView.bounds.width
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerView.systemLayoutSizeFitting(targetSize).height
        if headerView.frame.height != height {
            headerView.frame.size.height = height
            tableView.tableHeaderView = headerView
        }
    }
    
    
    
    private lazy var headView: UserInfoHeaderView = {
        let view = UserInfoHeaderView()
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.rowHeight = 104
        tableView.separatorStyle = .none
        return tableView
    }()

}
