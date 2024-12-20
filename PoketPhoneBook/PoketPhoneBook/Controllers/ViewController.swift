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
        tableView.delegate = self
        tableView.rowHeight = 80
        
        // 셀 등록
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    let memberListManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNaviBar()
        setupTableViewConstraints()
        
    }
    // 뷰가 나타나는 시점마다 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupNaviBar() {
        title = "친구 목록"
        // 네비게이션바 오른쪽 상단 버튼 설정
        let plusButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonTapped))
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
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
        return memberListManager.getMemberFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        // 멤버리스트매니저를 통해 받아온 데이터를 셀에 할당
        let member = memberListManager.getMemberFromCoreData()
        cell.memberData = member[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - 테이블뷰 델리게이트 구현 (셀이 선택되었을때)
extension ViewController: UITableViewDelegate {
    //선택적인 메서드, 셀이 선택되었을때 동작이 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phoneBookVC = PhoneBookViewController()
        // 클릭된 셀의 데이터 넘기기
        let selectedMember = memberListManager.getMemberFromCoreData()[indexPath.row]
        phoneBookVC.memberData = selectedMember
        // 화면이동
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
}
