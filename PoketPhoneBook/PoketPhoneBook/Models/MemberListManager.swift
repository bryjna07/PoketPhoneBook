//
//  MemberListManager.swift
//  PoketPhoneBook
//
//  Created by t2023-m0033 on 12/6/24.
//

import UIKit

// 멤버 비즈니스 로직 모델
final class MemberListManager {

    private var membersList: [Member] = []
    
    // 테스트 데이터
    func makeMembersListDatas() {
        membersList = [
            Member(memberImage: UIImage(systemName: "mug.fill") , name: "김르탄", phone: "010-1111-2222"),
            Member(memberImage: UIImage(systemName: "mug.fill") , name: "내배캠", phone: "010-2222-3333"),
            Member(memberImage: UIImage(systemName: "mug.fill") , name: "앱개발", phone: "010-3333-4444"),
            Member(memberImage: UIImage(systemName: "mug.fill") , name: "화이팅", phone: "010-5555-6666")
        ]
    }
    
    // 전체 멤버 리스트 얻기
    func getMembersList() -> [Member] {
        return membersList
    }
    
}
