//
//  PlanPointMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//
//

import Foundation
import CoreData


extension PlanPointMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanPointMO> {
        return NSFetchRequest<PlanPointMO>(entityName: "PlanPointMO")
    }

    @NSManaged public var oblast: String?
    @NSManaged public var region: String?
    @NSManaged public var imagePathStr: String?
    @NSManaged public var radiusInMeters: Double
    @NSManaged public var regionInMeters: Double

}
