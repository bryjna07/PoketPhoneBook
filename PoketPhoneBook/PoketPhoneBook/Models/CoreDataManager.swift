//
//  MemberListManager.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/6/24.
//

import UIKit
import CoreData

// 멤버 비즈니스 로직 모델
final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getMemberFromCoreData() -> [MemberData] {
        var memberList: [MemberData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서 생성
            let request = NSFetchRequest<MemberData>(entityName: MemberData.className)
            // 정렬순서를 정해서 요청서에 넘겨주기 (이름순, 오름차순 true)
            let nameOrder = NSSortDescriptor(key: MemberData.Key.name, ascending: true)
            request.sortDescriptors = [nameOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                let fetchedMemberList = try context.fetch(request)
                memberList = fetchedMemberList
            } catch {
                print("가져오는 것 실패")
            }
        }
        return memberList
        
    }
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveMemberData(name: String?, phone: String?, image: Data?, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if NSEntityDescription.entity(forEntityName: MemberData.className, in: context) != nil {
                
                let memberData = MemberData(context: context)
                    // MARK: - MemberData에 실제 데이터 할당
                    memberData.name = name
                    memberData.phoneNumber = phone
                    memberData.image = image
                    
                    appDelegate?.saveContext()
            }
        }
        completion()
    }
    
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteMember(data: MemberData, completion: @escaping () -> Void) {
        
        guard let name = data.name else {
            completion()
            return
        }
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<MemberData>(entityName: MemberData.className)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "name = %@", name as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                let fetchedMemberList = try context.fetch(request)
                
                // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                if let targetMember = fetchedMemberList.first {
                    context.delete(targetMember)
                    
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateMember(newMemberData: MemberData, completion: @escaping () -> Void) {
        // 이름 옵셔널 바인딩
        guard let name = newMemberData.name else {
            completion()
            return
        }
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<MemberData>(entityName: MemberData.className)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "name = %@", name as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기
                let fetchedMemberList = try context.fetch(request)
                    // 배열의 첫번째
                if var targetMember = fetchedMemberList.first {
                        
                        // MARK: - MemberData에 실제 데이터 재할당(바꾸기)
                        targetMember = newMemberData
                        
                        appDelegate?.saveContext()
                    }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
}
