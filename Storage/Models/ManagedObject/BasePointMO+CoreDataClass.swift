//
//  BasePointMO+CoreDataClass.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//
//

import Foundation
import CoreData

@objc(BasePointMO)
public class BasePointMO: NSManagedObject, MODescriptionPoint {
    public func toDTO() -> (any DTODescriptionPoint)? {
        return BasePointDTO.fromMO(self)
    }
    public func apply(dto: any DTODescriptionPoint) {
        self.uuid = dto.uuid
        self.date = dto.date
        self.latitude = dto.latitude
        self.longitude = dto.longitude
        self.name = dto.name
        self.descr = dto.descr
        self.isDisabled = dto.isDisabled
    }
}
