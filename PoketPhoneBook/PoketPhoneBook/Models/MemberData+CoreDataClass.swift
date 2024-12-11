//
//  MemberData+CoreDataClass.swift
//  PoketPhoneBook
//
//  Created by Watson22_YJ on 12/9/24.
//
//

import Foundation
import CoreData

@objc(MemberData)
public class MemberData: NSManagedObject {
    public static let className = "MemberData"
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let image = "image"
    }
}
