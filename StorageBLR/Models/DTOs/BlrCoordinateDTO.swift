//
//  BlrCoordinateDTO.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//

import Foundation
import CoreData


public struct BlrCoordinateDTO: DTODescriptionCoordinateBLR {

    public typealias MO = BlrCoordinateMO
    
    public var blr: BlrDTO?
    public var latitude: Double
    public var longitude: Double
    
    public init(
        blr: BlrDTO?,
        latitude: Double,
        longitude: Double
    ) {
        self.blr = blr
        self.latitude = latitude
        self.longitude = longitude
    }

    public static func fromMO(_ mo: MO) -> BlrCoordinateDTO? {
        
        var blr: BlrDTO? = nil
        
        if let blrMO = mo.blr {
            blr = BlrDTO.fromMO(blrMO)
        }
        
        return BlrCoordinateDTO(
            blr: blr,
            latitude: mo.latitude,
            longitude: mo.longitude
        )
    }
    
    public func createMO(context: NSManagedObjectContext) -> BlrCoordinateMO? {
        let mo = BlrCoordinateMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}
