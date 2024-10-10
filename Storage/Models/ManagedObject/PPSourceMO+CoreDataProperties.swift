//
//  PPSourceMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//
//

import Foundation
import CoreData


extension PPSourceMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PPSourceMO> {
        return NSFetchRequest<PPSourceMO>(entityName: "PPSourceMO")
    }

    @NSManaged public var uuidPoint: String?
    @NSManaged public var uuidSource: String?

}

extension PPSourceMO : Identifiable {

}
