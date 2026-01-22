// Views/UserInfoHeaderView.swift
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class UserInfoHeaderView: UIView {
    
    // MARK: - UI Components
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemOrange
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("查看资料", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // 使用 PublishRelay 替代 PublishSubject（更安全，不会发送 error 或 completed）
    let profileTapped = PublishRelay<Void>()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(levelLabel)
        addSubview(pointsLabel)
        addSubview(profileButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.equalTo(avatarImageView).offset(4)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        pointsLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(levelLabel.snp.bottom).offset(4)
        }
        
        profileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(avatarImageView)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    private func setupBindings() {
        // 将按钮点击事件绑定到 profileTapped relay
        profileButton.rx.tap
            .bind(to: profileTapped)
            .disposed(by: disposeBag)
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        levelLabel.text = "等级: Lv.\(user.level)"
        pointsLabel.text = "积分: \(user.points)"
        
        if let url = URL(string: user.avatar) {
            avatarImageView.kf.setImage(with: url)
        }
    }
}
