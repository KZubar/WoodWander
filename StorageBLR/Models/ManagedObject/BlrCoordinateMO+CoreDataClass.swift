//
//  BlrCoordinateMO+CoreDataClass.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//
//

import Foundation
import CoreData

@objc(BlrCoordinateMO)
public class BlrCoordinateMO: NSManagedObject, MODescriptionCoordinateBLR  {
    
    public func toDTO() -> (any DTODescriptionCoordinateBLR)? {
        return BlrCoordinateDTO.fromMO(self)
    }
    
    public func apply(dto: any DTODescriptionCoordinateBLR) {
        self.latitude   = dto.latitude
        self.longitude  = dto.longitude
    }
    
}
