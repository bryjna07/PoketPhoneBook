//
//  DetailViewController.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
import Alamofire
// MARK: - DetailViewController

final class PhoneBookViewController: UIViewController {
    
    private let phoneBookView = PhoneBookView()
    
    // 네트워크 매니저 (싱글톤)
    let networkManager = NetworkManager.shared
    // 코어데이터 매니저
    let memberListManager = CoreDataManager.shared
    
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
    
    func setupNaviBar() {
        title = "연락처 추가"
        
        // 네비게이션바 오른쪽 상단 버튼 설정
        let applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
        self.navigationItem.rightBarButtonItem = applyButton
    }
    
    @objc func applyButtonTapped() {
        //적용버튼 눌렀을 때
        let name = phoneBookView.nameTextField.text
        let phone = phoneBookView.phoneNumberTextField.text
        let image = phoneBookView.randomImageView.image
        // 이미지의 경우 JPEG로 변환하여 코어데이터에 저장 후 pop
        let imageData = image?.jpegData(compressionQuality: 0.5)
        memberListManager.saveMemberData(name: name, phone: phone, image: imageData) {
            print("저장 완료")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func randomButtonTapped(_ sender: UIButton) {
        fetchPoketmonData()
    }
    // 서버에서 포켓몬 데이터를 받아오는 메서드
    private func fetchPoketmonData() {
        let randomNum = Int.random(in: 1...1000)
        let url = URL(string: "\(requestUrl)\(randomNum)")
        guard let urlString = url else {
            print("잘못된 URL")
            return
        }
        
        networkManager.fetchDateByAlamofire(url: urlString) { [weak self] (result: Result<PoketmonData, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                
                guard let imageUrl = URL(string: result.sprites.other.home.imageUrl) else { return }
                
                // Alamofire 를 사용한 이미지 로드
                AF.request(imageUrl).responseData { response in
                    if let data = response.data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.phoneBookView.randomImageView.image = image
                        }
                    }
                }
            case .failure(let error):
                print("데이터 로드 실패: \(error)")
            }
        }
        // URL Session 사용시
        //        networkManager.fetchData(url: url!) { [weak self] (result: PoketmonData?) in
        //            guard let self, let result else { return }
        //            guard let imageUrl = URL(string: result.sprites.other.home.imageUrl) else { return }
        //
        //            // image를 로드하는 작업은 백그라운드 쓰레드에서 작업
        //            if let data = try? Data(contentsOf: imageUrl) {
        //                if let image = UIImage(data: data) {
        //
        //                    DispatchQueue.main.async {
        //                        self.phoneBookView.randomImageView.image = image
        //                    }
        //                }
        //            }
        //        }
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
        if string.isEmpty {
            return true
        }
        if textField == phoneBookView.nameTextField {
            return Int(string) == nil // 이름 필드에 숫자 입력 안되게
        } else if textField == phoneBookView.phoneNumberTextField {
            return Int(string) != nil // 전화번호 필드에 문자 입력 안되게
        }
        return true
    }
    
}
