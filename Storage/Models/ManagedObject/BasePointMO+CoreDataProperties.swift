//
//  BasePointMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//
//

import Foundation
import CoreData


extension BasePointMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BasePointMO> {
        return NSFetchRequest<BasePointMO>(entityName: "BasePointMO")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var date: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var descr: String?
    @NSManaged public var name: String?
    @NSManaged public var isDisabled: Bool

}

extension BasePointMO : Identifiable { }
