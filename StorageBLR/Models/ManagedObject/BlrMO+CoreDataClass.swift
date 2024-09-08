//
//  BlrMO+CoreDataClass.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//
//

import CoreData

@objc(BlrMO)
public class BlrMO: NSManagedObject, MODescriptionBLR {
    
    public func toDTO() -> (any DTODescriptionBLR)? {
        return BlrDTO.fromMO(self)
    }
    
    public func apply(dto: any DTODescriptionBLR) {
        self.latitude   = dto.latitude
        self.longitude  = dto.longitude
        self.country    = dto.country
        self.engType_1  = dto.engType_1
        self.engType_2  = dto.engType_2
        self.gid_0      = dto.gid_0
        self.gid_1      = dto.gid_1
        self.gid_2      = dto.gid_2
        self.hasc_1     = dto.hasc_1
        self.hasc_2     = dto.hasc_2
        self.name_0     = dto.name_0
        self.name_1     = dto.name_1
        self.name_2     = dto.name_2
        self.nl_name_1  = dto.nl_name_1
        self.nl_name_2  = dto.nl_name_2
        self.type_0     = dto.type_0
        self.type_1     = dto.type_1
        self.type_2     = dto.type_2
        self.varname_1  = dto.varname_1
        self.varname_2  = dto.varname_2
    }
    
}

