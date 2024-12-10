//
//  MemberData+CoreDataProperties.swift
//  PoketPhoneBook
//
//  Created by t2023-m0033 on 12/9/24.
//
//

import Foundation
import CoreData


extension MemberData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberData> {
        return NSFetchRequest<MemberData>(entityName: "MemberData")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var image: Data?

}

extension MemberData : Identifiable {

}
