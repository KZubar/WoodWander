//
//  PPCategoriesMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 7.09.24.
//
//

import Foundation
import CoreData

extension PPCategoriesMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PPCategoriesMO> {
        return NSFetchRequest<PPCategoriesMO>(entityName: "PPCategoriesMO")
    }

    @NSManaged public var descr: String?
    @NSManaged public var isUsed: Bool
    @NSManaged public var uuidCategory: String?
    @NSManaged public var uuidPoint: String?

}

extension PPCategoriesMO : Identifiable {

}
