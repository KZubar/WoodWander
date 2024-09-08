//
//  PlanPointMO+CoreDataClass.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//
//

import Foundation
import CoreData

@objc(PlanPointMO)
public class PlanPointMO: NSManagedObject, MODescriptionPlanPoint {
    
    public func toDTO() -> (any  DTODescriptionPlanPoint)? {
        return PlanPointDTO.fromMO(self)
    }

    public func apply(dto: any DTODescriptionPlanPoint) {
        guard let planDTO = dto as? PlanPointDTO
        else {
            print("[MODTO]", "\(Self.self) apply failed: dto is type off \(type(of: dto))")
            return
        }
        
        self.uuid = planDTO.uuid
        self.date = planDTO.date
        self.latitude = planDTO.latitude
        self.longitude = planDTO.longitude
        self.name = planDTO.name
        self.descr = planDTO.descr
        self.isDisabled = planDTO.isDisabled
        self.oblast = planDTO.oblast
        self.region = planDTO.region
        self.color = planDTO.color ?? ""
        self.icon = planDTO.icon ?? ""
        self.imagePathStr = planDTO.imagePathStr
        self.radiusInMeters = planDTO.radiusInMeters
        self.regionInMeters = planDTO.regionInMeters
        
    }
}
