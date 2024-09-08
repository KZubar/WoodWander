//
//  PlanPointMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 7.09.24.
//
//

import Foundation
import CoreData


extension PlanPointMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanPointMO> {
        return NSFetchRequest<PlanPointMO>(entityName: "PlanPointMO")
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var descr: String?
    @NSManaged public var icon: String?
    @NSManaged public var imagePathStr: String?
    @NSManaged public var isDisabled: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var oblast: String?
    @NSManaged public var radiusInMeters: Double
    @NSManaged public var region: String?
    @NSManaged public var regionInMeters: Double
    @NSManaged public var uuid: String?

}

extension PlanPointMO : Identifiable {

}
