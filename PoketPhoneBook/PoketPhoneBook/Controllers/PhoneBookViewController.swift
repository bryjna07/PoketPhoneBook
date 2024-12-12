//
//  DetailViewController.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
import Alamofire
import SnapKit
// MARK: - DetailViewController
final class PhoneBookViewController: UIViewController {
    
    private let phoneBookView = PhoneBookView()
    
    // 네트워크 매니저 (싱글톤)
    let networkManager = NetworkManager.shared
    // 코어데이터 매니저
    let coreDataManager = CoreDataManager.shared
    
    // MemberData를 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행)
    var memberData: MemberData? {
        didSet {
            configureSelectedData()
        }
    }
    
    override func loadView() {
        self.view = phoneBookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setup()
    }
    
    func setup() {
        phoneBookView.nameTextField.delegate = self
        phoneBookView.phoneNumberTextField.delegate = self
        phoneBookView.randomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
    }
    // 정보 유무에 따른 네비바버튼 이름 변경
    func setupNaviBar() {
        if memberData != nil {
            let updateButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(updateButtonTapped))
            self.navigationItem.rightBarButtonItem = updateButton
        } else {
            let applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
            title = "연락처 추가"
            self.navigationItem.rightBarButtonItem = applyButton
        }
    }
    // MARK: - SELETED CELL
    // 선택된 셀의 정보를 받아 UI 표시하기
    func configureSelectedData() {
        
        if memberData != nil {
            title = memberData?.name
            phoneBookView.nameTextField.text = memberData?.name
            phoneBookView.phoneNumberTextField.text = memberData?.phoneNumber?.withoutHyphen
            if let imageData = memberData?.image, let image = UIImage(data: imageData) {
                phoneBookView.randomImageView.image = image
            }
            // 정보가 있을 시 삭제버튼 생성
            let deleteButton: UIButton = {
                let button = UIButton()
                button.setTitle("삭제", for: .normal)
                button.backgroundColor = .lightGray
                button.titleLabel?.font = .systemFont(ofSize: 14)
                button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
                return button
            }()
            phoneBookView.addSubview(deleteButton)
            deleteButton.snp.makeConstraints { make in
                make.top.equalTo(phoneBookView.phoneNumberTextField.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
        }
    }
    // MARK: - CREATE
    @objc func applyButtonTapped() {
        //적용버튼 눌렀을 때
        let name = phoneBookView.nameTextField.text
        let phone = phoneBookView.phoneNumberTextField.text?.withHypen
        let image = phoneBookView.randomImageView.image
        if (name?.count != 0) && (phone!.count > 9) && image != nil {
            // 이미지의 경우 JPEG로 변환하여 코어데이터에 저장 후 pop
            let imageData = image?.jpegData(compressionQuality: 0.5)
            coreDataManager.saveMemberData(name: name, phone: phone, image: imageData) {
                print("저장 완료")
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let alert = UIAlertController(title: "적용 실패", message: "올바른 정보를 입력해주세요!", preferredStyle: .alert)
            let succes = UIAlertAction(title: "확인", style: .default)
            alert.addAction(succes)
            present(alert, animated: true)
        }
    }
    // MARK: - UPDATE
    // 수정 버튼 클릭 시
    @objc func updateButtonTapped() {
        
        if let memberData = self.memberData {
            memberData.name = phoneBookView.nameTextField.text
            memberData.phoneNumber = phoneBookView.phoneNumberTextField.text?.withHypen
            memberData.image = phoneBookView.randomImageView.image?.jpegData(compressionQuality: 0.5)
            if (memberData.name!.count != 0) && (memberData.phoneNumber!.count > 9) && memberData.image != nil {
                coreDataManager.updateMember(newMemberData: memberData) {
                    print("수정 완료")
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                let alert = UIAlertController(title: "수정 실패", message: "올바른 정보를 입력해주세요!", preferredStyle: .alert)
                let succes = UIAlertAction(title: "확인", style: .default)
                alert.addAction(succes)
                present(alert, animated: true)
            }
            
        }
    }
    // MARK: - DELETE
    // 삭제 버튼 클릭 시
    @objc func deleteButtonTapped() {
        // 알럿창 띄우기 - 확인 클릭 시 삭제
        let alert = UIAlertController(title: "연락처 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let succes = UIAlertAction(title: "확인", style: .default) { action in
            if let memberData = self.memberData {
                self.coreDataManager.deleteMember(data: memberData) {
                    print("삭제 완료")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(succes)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    // MARK: - API 랜덤 이미지 받아오기
    @objc func randomButtonTapped(_ sender: UIButton) {
        networkManager.fetchRandomPoketmonData { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let poketmon):
                    // 이미지 URL 설정
                    if let imageUrl = poketmon.sprites?.other?.home?.imageUrl {
                        self.phoneBookView.imageUrl = imageUrl
                    } else {
                        print("이미지 URL 없음")
                    }
                case .failure(let error):
                    print("포켓몬 데이터 로드 실패: \(error)")
                }
            }
        }
    }
    
    // 다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneBookView.endEditing(true)
    }
}

// MARK: - 텍스트필드 델리게이트
extension PhoneBookViewController: UITextFieldDelegate {
    
    // 다음 눌렀을때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneBookView.nameTextField {
            phoneBookView.phoneNumberTextField.becomeFirstResponder() // 다음 텍스트필드로 이동
        } else if textField == phoneBookView.phoneNumberTextField {
            textField.resignFirstResponder() // 키보드 내리기
        }
        return true
    }
    
    // 텍스트필드에 글자내용이 변할때마다 관련 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백스페이스 허용 코드
        if string.isEmpty {
            return true
        }
        if textField == phoneBookView.nameTextField {
            return Int(string) == nil // 이름 필드에 숫자 입력 안되게
        } else if textField == phoneBookView.phoneNumberTextField {
            // 11글자이상 입력되는 것을 막는 코드
            if (textField.text?.count)! + string.count > 11 {
                return false
            }
            return Int(string) != nil // 전화번호 필드에 문자 입력 안되게
        }
        return true
    }
    
}
// MARK: - 휴대폰 번호 하이픈 추가
extension String {
    
    public var withHypen: String {
        var stringWithHypen: String = self
        guard self.count == 10 || self.count == 11 else { return self } // 10자리나 11자리만 처리
        
        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        
        return stringWithHypen
    }
    
    /// 하이픈 제거 메서드
    public var withoutHyphen: String {
        return self.replacingOccurrences(of: "-", with: "")
    }
}
