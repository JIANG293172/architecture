//
//  CarStatusHeaderView.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

// Views/CarStatusHeaderView.swift
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CarStatusHeaderView: UIView {
    
    // MARK: - UI Components
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "car.fill")
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let carNameLabel: UILabel = {
        let label = UILabel()
        label.text = "长安深蓝 SL03"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let statusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private let totalMileageView = StatusItemView()
    private let remainingRangeView = StatusItemView()
    private let currentRangeView = StatusItemView()
    
    private let moreControlButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("更多控制", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(carImageView)
        addSubview(carNameLabel)
        addSubview(statusStackView)
        addSubview(moreControlButton)
        
        statusStackView.addArrangedSubview(totalMileageView)
        statusStackView.addArrangedSubview(remainingRangeView)
        statusStackView.addArrangedSubview(currentRangeView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        carImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        
        carNameLabel.snp.makeConstraints { make in
            make.top.equalTo(carImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        statusStackView.snp.makeConstraints { make in
            make.top.equalTo(carNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        moreControlButton.snp.makeConstraints { make in
            make.top.equalTo(statusStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with status: CarStatus) {
        totalMileageView.configure(title: "总里程", value: "\(status.totalMileage)km")
        remainingRangeView.configure(title: "剩余续航", value: "\(status.remainingRange)km")
        currentRangeView.configure(title: "当前里程", value: "\(status.currentRange)km")
    }
}

// Views/StatusItemView.swift
import UIKit
import SnapKit

class StatusItemView: UIView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(valueLabel)
        addSubview(titleLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

// Views/FunctionCell.swift
import UIKit
import RxSwift
import SnapKit

class FunctionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FunctionCell"
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func configure(with function: ControlFunction) {
        nameLabel.text = function.name
        iconImageView.image = UIImage(systemName: function.icon)
    }
}

// Views/BannerCell.swift
import UIKit
import Kingfisher
import SnapKit
import FSPagerView

class BannerCell: FSPagerViewCell {  // 改为继承 FSPagerViewCell
    
    static let reuseIdentifier = "BannerCell"
    
    // MARK: - UI Components
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(bannerImageView)
        bannerImageView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        bannerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
    func configure(with banner: Banner) {
        titleLabel.text = banner.title
        if let url = URL(string: banner.imageUrl) {
            bannerImageView.kf.setImage(with: url)
        }
    }
}
