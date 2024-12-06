//
//  ViewController.swift
//  PoketPhoneBook
//
//  Created by t2023-m0033 on 12/6/24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNaviBar()
        setupTableViewConstraints()
  
    }
    
    func setupNaviBar() {
        title = "친구 목록"
        
        // 네비게이션바 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }

    //MARK: - 오토레이아웃 셋팅
    
    // 테이블뷰의 오토레이아웃 설정
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
}

#Preview {
    ViewController()
}
