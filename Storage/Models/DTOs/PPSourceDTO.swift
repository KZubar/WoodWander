//
//  PPSourceDTO.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//

import Foundation
import CoreData

public struct PPSourceDTO: DTODescriptionPPSource {
        
    public typealias MO = PPSourceMO

    public var uuidPoint: String
    public var uuidSource: String

    public init(uuidPoint: String, uuidSource: String) {
        self.uuidPoint = uuidPoint
        self.uuidSource = uuidSource
    }

    public static func fromMO(_ mo: PPSourceMO) -> PPSourceDTO? {
        guard
            let uuidPoint = mo.uuidPoint,
            let uuidSource = mo.uuidSource
        else { return nil }
        
        return PPSourceDTO(uuidPoint: uuidPoint, uuidSource: uuidSource)
    }
    
    public func createMO(context: NSManagedObjectContext) -> PPSourceMO? {
        let mo = PPSourceMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}

