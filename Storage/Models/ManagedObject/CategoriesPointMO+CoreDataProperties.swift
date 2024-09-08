//
//  CategoriesPointMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 7.09.24.
//
//

import Foundation
import CoreData


extension CategoriesPointMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoriesPointMO> {
        return NSFetchRequest<CategoriesPointMO>(entityName: "CategoriesPointMO")
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var descr: String?
    @NSManaged public var icon: String?
    @NSManaged public var isDisabled: Bool
    @NSManaged public var name: String?
    @NSManaged public var predefined: Bool
    @NSManaged public var uuid: String?

}

extension CategoriesPointMO : Identifiable {

}
