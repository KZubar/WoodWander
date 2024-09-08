//
//  BlrMO+CoreDataProperties.swift
//  StorageBLR
//
//  Created by k.zubar on 7.07.24.
//
//

import Foundation
import CoreData


extension BlrMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlrMO> {
        return NSFetchRequest<BlrMO>(entityName: "BlrMO")
    }

    @NSManaged public var country: String?
    @NSManaged public var engType_1: String?
    @NSManaged public var gid_0: String?
    @NSManaged public var gid_1: String?
    @NSManaged public var gid_2: String?
    @NSManaged public var hasc_1: String?
    @NSManaged public var name_0: String?
    @NSManaged public var name_1: String?
    @NSManaged public var name_2: String?
    @NSManaged public var nl_name_1: String?
    @NSManaged public var type_0: String?
    @NSManaged public var type_1: String?
    @NSManaged public var type_2: String?
    @NSManaged public var engType_2: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var hasc_2: String?
    @NSManaged public var nl_name_2: String?
    @NSManaged public var varname_1: String?
    @NSManaged public var varname_2: String?
    @NSManaged public var coordinates: NSSet?

}

// MARK: Generated accessors for coordinates
extension BlrMO {

    @objc(addCoordinatesObject:)
    @NSManaged public func addToCoordinates(_ value: BlrCoordinateMO)

    @objc(removeCoordinatesObject:)
    @NSManaged public func removeFromCoordinates(_ value: BlrCoordinateMO)

    @objc(addCoordinates:)
    @NSManaged public func addToCoordinates(_ values: NSSet)

    @objc(removeCoordinates:)
    @NSManaged public func removeFromCoordinates(_ values: NSSet)

}

extension BlrMO : Identifiable {

}
