//
//  SourcePointMO+CoreDataProperties.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//
//

import Foundation
import CoreData


extension SourcePointMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourcePointMO> {
        return NSFetchRequest<SourcePointMO>(entityName: "SourcePointMO")
    }

    @NSManaged public var descr: String?
    @NSManaged public var name: String?
    @NSManaged public var uuid: String?

}

extension SourcePointMO : Identifiable {

}
