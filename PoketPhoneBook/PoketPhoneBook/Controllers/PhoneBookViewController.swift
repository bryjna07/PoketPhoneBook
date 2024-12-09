//
//  DetailViewController.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
    // MARK: - DetailViewController

final class PhoneBookViewController: UIViewController {
    
    private let phoneBookView = PhoneBookView()
    
    // 네비게이션바에 넣기 위한 버튼
    private lazy var applyButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "적용")
        button.tintColor = .systemBlue
        return button
    }()

    // MVC패턴을 위해서, view교체
    override func loadView() {
        view = phoneBookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()

    }
    
    func setupNaviBar() {
        title = "연락처 추가"
        
        // 네비게이션바 설정관련
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()  // 불투명으로
//        appearance.backgroundColor = .white
//   //     navigationController?.navigationBar.tintColor = .systemBlue
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션바 오른쪽 상단 버튼 설정
        self.navigationItem.rightBarButtonItem = self.applyButton
    }
    



}
