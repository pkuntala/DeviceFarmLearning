//
//  AppInternalsStatesMO+CoreDataProperties.swift
//  Superheroes
//
//  Created by Chris Davis J on 17/12/21.
//
//

import Foundation
import CoreData


extension AppInternalsStatesMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppInternalsStatesMO> {
        return NSFetchRequest<AppInternalsStatesMO>(entityName: "AppInternalsStatesMO")
    }

    @NSManaged public var accessibilitySpeech: Bool
    @NSManaged public var userLogged: UserMO?

}

extension AppInternalsStatesMO : Identifiable {

}
