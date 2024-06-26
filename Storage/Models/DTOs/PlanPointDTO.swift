//
//  PlanPointDTO.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import Foundation
import CoreData

public struct PlanPointDTO: DTODescriptionPoint {
    
    public typealias MO = PlanPointMO

    public var uuid: String?
    public var date: Date?
    public var latitude: Double
    public var longitude: Double
    public var name: String?
    public var descr: String?
    public var isDisabled: Bool
    
    public var oblast: String?
    public var region: String?
    public var imagePathStr: String?
    public var radiusInMeters: Double
    public var regionInMeters: Double

    public init(
        uuid: String?,
        date: Date?,
        latitude: Double,
        longitude: Double,
        name: String?,
        descr: String?,
        isDisabled: Bool,
        oblast: String?,
        region: String?,
        regionInMeters: Double,
        radiusInMeters: Double,
        imagePathStr: String?
    ) {
        self.uuid = uuid
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.descr = descr
        self.isDisabled = isDisabled
        
        self.oblast = oblast
        self.region = region
        self.imagePathStr = imagePathStr
        self.radiusInMeters = radiusInMeters
        self.regionInMeters = regionInMeters
    }
    
    public static func fromMO(_ mo: PlanPointMO) -> PlanPointDTO? {
        guard
            let uuid = mo.uuid,
            let date = mo.date,
            let name = mo.name,
            let descr = mo.descr,
            let oblast = mo.oblast,
            let region = mo.region,
            let imagePathStr = mo.imagePathStr
        else { return nil }
        
        return PlanPointDTO(uuid: uuid,
                            date: date,
                            latitude: mo.latitude,
                            longitude: mo.longitude,
                            name: name,
                            descr: descr,
                            isDisabled: mo.isDisabled,
                            oblast: oblast,
                            region: region,
                            regionInMeters: mo.regionInMeters,
                            radiusInMeters: mo.radiusInMeters,
                            imagePathStr: imagePathStr)

    }
    
    public func createMO(context: NSManagedObjectContext) -> PlanPointMO? {
        let mo = PlanPointMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}
