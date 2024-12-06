//
//  ViewController.swift
//  PoketPhoneBook
//
//  Created by t2023-m0033 on 12/6/24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        // 셀 등록 ⭐️
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    var memberListManager = MemberListManager()
    
    // 네비게이션바에 넣기 위한 버튼
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonTapped))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDatas()
        setupNaviBar()
        setupTableViewConstraints()
        
        
        
    }
    
    func setupNaviBar() {
        title = "친구 목록"
        
        // 네비게이션바 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션바 오른쪽 상단 버튼 설정
        self.navigationItem.rightBarButtonItem = self.plusButton
    }
    
    func setupDatas() {
        memberListManager.makeMembersListDatas()
    }
    
    //MARK: - 오토레이아웃
    
    // 테이블뷰의 오토레이아웃 설정
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // 추가버튼
    @objc func plusButtonTapped() {
        print("추가버튼 클릭")
        
    }
    
}
    // MARK: - 테이블뷰 확장

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberListManager.getMembersList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        
        let member = memberListManager.getMembersList()[indexPath.row]
        
        cell.mainImageView.image = member.memberImage
        cell.memberNameLabel.text = member.name
        cell.phoneNumberLabel.text = member.phone
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
