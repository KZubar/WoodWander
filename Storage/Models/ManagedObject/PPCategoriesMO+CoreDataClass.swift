//
//  PPCategoriesMO+CoreDataClass.swift
//  Storage
//
//  Created by k.zubar on 1.09.24.
//
//

import Foundation
import CoreData

@objc(PPCategoriesMO)
public class PPCategoriesMO: NSManagedObject, MODescriptionPPCategories {
    
    public func toDTO() -> (any  DTODescriptionPPCategories)? {
        return PPCategoriesDTO.fromMO(self)
    }

    public func apply(dto: any DTODescriptionPPCategories) {
        guard let itemDTO = dto as? PPCategoriesDTO
        else {
            print("[MODTO]", "\(Self.self) apply failed: dto is type off \(type(of: dto))")
            return
        }

        self.uuidPoint = itemDTO.uuidPoint
        self.uuidCategory = itemDTO.uuidCategory
        self.descr = itemDTO.descr
        self.isUsed = itemDTO.isUsed

    }
}
