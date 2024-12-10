//
//  TableViewCell.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
    // MARK: - MainView(Cell) UI
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
    
    private lazy var nameStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [memberNameLabel, phoneNumberLabel])
        stview.spacing = 30
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    // MemberData를 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행)
    var memberData: MemberData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위함
        self.mainImageView.image = nil
    }
    
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
  
    private func configureUI() {
        [
            mainImageView,
            nameStackView
        ].forEach { contentView.addSubview($0) }
        
        mainImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
        nameStackView.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        memberNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
    }
    
    // 저장된 데이터로 UI 표시하기
    func configureUIwithData() {
        memberNameLabel.text = memberData?.name
        phoneNumberLabel.text = memberData?.phoneNumber
        // 변환한 이미지를 메인이미지에 담기
        if let imageData = memberData?.image, let image = UIImage(data: imageData) {
            mainImageView.image = image
        } else {
            mainImageView.image = UIImage(named: "ball") // 기본 이미지 설정
        }
    }
}
