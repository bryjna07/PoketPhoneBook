//
//  DetailView.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
    // MARK: - DetailView UI
final class PhoneBookView: UIView {
    
    //MARK: - UI구현
    
    let randomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // 정렬을 깔끔하게 하기 위한 컨테이너뷰
    private lazy var imageContainView: UIView = {
        let view = UIView()
        [
            randomImageView,
            randomButton
        ].forEach { view.addSubview($0) }
        //view.backgroundColor = .yellow
        return view
    }()
    
    let randomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()

    private let nameGuideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "이       름:"
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 25
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.returnKeyType = .next
        return tf
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [nameGuideLabel, nameTextField])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    private let phoneGuideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "전화번호:"
        return label
    }()
    
    let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 25
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.keyboardType = .numberPad
        tf.placeholder = "01012345678"
        return tf
    }()
    
    private lazy var phoneStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [phoneGuideLabel, phoneNumberTextField])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    private lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [imageContainView, nameStackView, phoneStackView])
        stview.spacing = 15
        stview.axis = .vertical
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    
    //MARK: - 생성자 셋팅
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
       // MARK: - 오토레이아웃
    private func configureUI()  {
        self.addSubview(stackView)
        
        randomImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(150)
        }
        randomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(randomImageView.snp.bottom).offset(8)
        }
        imageContainView.snp.makeConstraints { make in
            make.height.equalTo(210)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nameGuideLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        phoneGuideLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
    }
}
