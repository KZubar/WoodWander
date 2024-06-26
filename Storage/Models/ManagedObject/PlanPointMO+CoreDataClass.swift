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
public class PlanPointMO: BasePointMO {
    
    public override func toDTO() -> (any  DTODescriptionPoint)? {
        return PlanPointDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescriptionPoint) {
        guard let planDTO = dto as? PlanPointDTO
        else {
            print("[MODTO]", "\(Self.self) apply failed: dto is type off \(type(of: dto))")
            return
        }
        
        super.apply(dto: planDTO)
        
        self.oblast = planDTO.oblast
        self.region = planDTO.region
        self.imagePathStr = planDTO.imagePathStr
        self.radiusInMeters = planDTO.radiusInMeters
        self.regionInMeters = planDTO.regionInMeters
        
    }
}
