//
//  PPSourceMO+CoreDataClass.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//
//

import Foundation
import CoreData


@objc(PPSourceMO)
public class PPSourceMO: NSManagedObject, MODescriptionPPSource {
    
    public func toDTO() -> (any DTODescriptionPPSource)? {
        return PPSourceDTO.fromMO(self)
    }

    public func apply(dto: any DTODescriptionPPSource) {
        guard let itemDTO = dto as? PPSourceDTO
        else {
            print("[MODTO]", "\(Self.self) apply failed: dto is type off \(type(of: dto))")
            return
        }
        
        self.uuidSource = itemDTO.uuidSource
        self.uuidPoint = itemDTO.uuidPoint
    }

}
