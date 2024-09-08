//
//  BlrCoordinateMO+CoreDataProperties.swift
//  StorageBLR
//
//  Created by k.zubar on 7.07.24.
//
//

import Foundation
import CoreData


extension BlrCoordinateMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlrCoordinateMO> {
        return NSFetchRequest<BlrCoordinateMO>(entityName: "BlrCoordinateMO")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var blr: BlrMO?

}

extension BlrCoordinateMO : Identifiable {

}
