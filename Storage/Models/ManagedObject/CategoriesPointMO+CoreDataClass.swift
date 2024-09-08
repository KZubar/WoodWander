//
//  CategoriesPointMO+CoreDataClass.swift
//  Storage
//
//  Created by k.zubar on 21.08.24.
//
//

import Foundation
import CoreData

@objc(CategoriesPointMO)
public class CategoriesPointMO: NSManagedObject, MODescriptionCategoriesPoint  {

    public func toDTO() -> (any DTODescriptionCategoriesPoint)? {
        return CategoriesPointDTO.fromMO(self)
    }

    public func apply(dto: any DTODescriptionCategoriesPoint) {
        guard let categoriesPointDTO = dto as? CategoriesPointDTO
        else {
            print("[MODTO]", "\(Self.self) apply failed: dto is type off \(type(of: dto))")
            return
        }
        
        self.color = categoriesPointDTO.color
        self.date = categoriesPointDTO.date
        self.descr = categoriesPointDTO.descr
        self.icon = categoriesPointDTO.icon
        self.isDisabled = categoriesPointDTO.isDisabled
        self.name = categoriesPointDTO.name
        self.uuid = categoriesPointDTO.uuid
        self.predefined = categoriesPointDTO.predefined
    }
    

}
