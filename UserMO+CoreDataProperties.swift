//
//  UserMO+CoreDataProperties.swift
//  Superheroes
//
//  Created by Murukuri Tejasvi Sri Kanaka Lakshmi  on 16/12/21.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }

    @NSManaged public var userId: String?
    @NSManaged public var password: String?
    @NSManaged public var userName: String?
    @NSManaged public var userPh: String?
    @NSManaged public var userDp: Data?
    @NSManaged public var report: Data?

}

extension UserMO : Identifiable {

}
