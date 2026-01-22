//
//  ProductCell.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/6.
//

import RxSwift
import SnapKit
import Kingfisher
import UIKit

class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"
    private var disposeBag = DisposeBag()
    
    var favoriteTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(favoriteButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12).priority(.high)
            make.width.height.equalTo(80)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
            make.top.equalTo(productImageView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(productImageView)
        }
        
        originalPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(8)
            make.centerY.equalTo(priceLabel)
        }
        
        stockLabel.snp.makeConstraints { make in
            make.trailing.equalTo(nameLabel)
            make.centerY.equalTo(priceLabel)
        }
 
    }
    
    private func setupBindings() {
        favoriteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.favoriteTapped?()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = "$\(product.price)"
        stockLabel.text = "库存： \(product.stock)"
        favoriteButton.isSelected = product.isFavorite
        
        if let originalPrice = product.originalPrice {
            let attributedString = NSAttributedString(
            string: "￥\(originalPrice)",
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            originalPriceLabel.attributedText = attributedString
            originalPriceLabel.isHidden = false
        } else {
            originalPriceLabel.isHidden = true
        }
        
        if let url = URL(string: product.imageUrl) {
            productImageView.kf.setImage(with: url)
        }
    }
    
    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemRed
        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        return button
    }()
    
    
    
}
