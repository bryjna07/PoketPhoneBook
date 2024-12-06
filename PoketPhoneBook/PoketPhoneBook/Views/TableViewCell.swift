//
//  TableViewCell.swift
//  PoketPhoneBook
//
//  Created by t2023-m0033 on 12/6/24.
//

import UIKit

final class TableViewCell: UITableViewCell {
    // 저장속성 . 접근용이, 실수방지
    static let id = "MemberCell"
    
    
    //MARK: - UI구현
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - 생성자 셋팅
    // 셀 생성자
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 오토레이아웃 셋팅
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func configureUI() {
        [
            mainImageView,
            memberNameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        mainImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
        memberNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
    }
    
    
}
