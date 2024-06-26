//
//  BasePointDTO.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import Foundation
import CoreData

public struct BasePointDTO: DTODescriptionPoint {

    public typealias MO = BasePointMO
        
    public var uuid: String
    public var date: Date?
    public var latitude: Double
    public var longitude: Double
    public var descr: String?
    public var name: String?
    public var isDisabled: Bool

    public init(uuid: String = UUID().uuidString,
                date: Date?,
                latitude: Double,
                longitude: Double,
                descr: String?,
                name: String?,
                isDisabled: Bool = false) {
        self.date = date
        self.uuid = uuid
        self.latitude = latitude
        self.longitude = longitude
        self.descr = descr
        self.name = name
        self.isDisabled = isDisabled
    }

    public static func fromMO(_ mo: MO) -> BasePointDTO? {
        guard
            let uuid = mo.uuid,
            let date = mo.date,
            let descr = mo.descr,
            let name = mo.name

        else { return nil }
        
        return BasePointDTO(uuid: uuid,
                            date: date,
                            latitude: mo.latitude,
                            longitude: mo.longitude,
                            descr: descr,
                            name: name,
                            isDisabled: mo.isDisabled)
 
    }
    
    public func createMO(context: NSManagedObjectContext) -> BasePointMO? {
        let mo = BasePointMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}
