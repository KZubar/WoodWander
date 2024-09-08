//
//  PPCategoriesDTO.swift
//  Storage
//
//  Created by k.zubar on 1.09.24.
//


import Foundation
import CoreData

public struct PPCategoriesDTO: DTODescriptionPPCategories {
        
    public typealias MO = PPCategoriesMO

    public var uuidPoint: String
    public var uuidCategory: String
    public var descr: String?
    public var isUsed: Bool

    public init(
        uuidPoint: String,
        uuidCategory: String,
        descr: String?,
        isUsed: Bool
    ) {
        self.uuidPoint = uuidPoint
        self.uuidCategory = uuidCategory
        self.descr = descr
        self.isUsed = isUsed
    }

    public static func fromMO(_ mo: PPCategoriesMO) -> PPCategoriesDTO? {
        guard
            let uuidPoint = mo.uuidPoint,
            let uuidCategory = mo.uuidCategory,
            let descr = mo.descr
        else { return nil }
        
        return PPCategoriesDTO(uuidPoint: uuidPoint,
                                      uuidCategory: uuidCategory,
                                      descr: descr,
                                      isUsed: mo.isUsed)

    }
    
    public func createMO(context: NSManagedObjectContext) -> PPCategoriesMO? {
        let mo = PPCategoriesMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}

