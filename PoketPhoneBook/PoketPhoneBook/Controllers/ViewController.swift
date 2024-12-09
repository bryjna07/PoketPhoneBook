//
//  ViewController.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
import SnapKit
    // MARK: - MainViewController

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
    private lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonTapped))
        button.tintColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
        setupNaviBar()
        setupTableViewConstraints()
        setupDatas()
    }
    
    private func setupNaviBar() {
        title = "친구 목록"
        
        // 네비게이션바 설정관련
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()  // 불투명으로
//        appearance.backgroundColor = .white
//     //   navigationController?.navigationBar.tintColor = .gray
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
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
    
     // 추가버튼 클릭 시 다음 화면으로 이동
    @objc func plusButtonTapped() {
        // 다음화면으로 이동 (멤버는 전달하지 않음)
        let phoneBookVC = PhoneBookViewController()
        
        // 화면이동
        navigationController?.pushViewController(phoneBookVC, animated: true)
     
    }
}
    // MARK: - 테이블뷰 확장

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberListManager.getMembersList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        // 멤버리스트매니저를 통해 받아온 데이터를 셀에 할당
        let member = memberListManager.getMembersList()[indexPath.row]
        
        cell.mainImageView.image = member.memberImage
        cell.memberNameLabel.text = member.name
        cell.phoneNumberLabel.text = member.phone
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
