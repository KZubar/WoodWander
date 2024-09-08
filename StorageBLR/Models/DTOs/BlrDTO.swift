//
//  BlrDTO.swift
//  Storage
//
//  Created by k.zubar on 3.07.24.
//

import Foundation
import CoreData


public struct BlrDTO: DTODescriptionBLR {

    public typealias MO = BlrMO

    //MARK: - isGid + predicate
    public var isGid_0: Bool {
        return (self.gid_0 != nil) && (self.gid_1 == nil) && (self.gid_2 == nil)
    }
    public var isGid_1: Bool {
        return (self.gid_0 != nil) && (self.gid_1 != nil) && (self.gid_2 == nil)
    }
    public var isGid_2: Bool {
        return (self.gid_0 != nil) && (self.gid_1 != nil) && (self.gid_2 != nil)
    }
    public var gid: String? {
        if isGid_0 == true { return gid_0 }
        else if isGid_1 == true { return gid_1 }
        else if isGid_2 == true { return gid_2 }
        return nil
    }
    public var predicate: NSPredicate? {
        guard let gid = self.gid else { return nil }
        
        if isGid_0 == true { return .BLR.blr0(byId: gid) }
        else if isGid_1 == true { return .BLR.blr1(byId: gid) }
        else if isGid_2 == true { return .BLR.blr2(byId: gid) }
        
        return nil
    }
    //
    
    //MARK: - value + title + subtitle
    public var title: String? {
        var result: String?
        
        if let country = self.country {
            result = "\(country)"
        }
        if let type = self.type_1, let name = self.name_1 {
            result = "\(type) \(name)"
        }
        if let type = self.type_2, let name = self.name_2 {
            result = "\(type) \(name)"
        }
        return result
    }
    
    public var subtitle: String? {
        var result: String?
        
        if let gid = self.gid_0 {
            result = "\(gid)"
        }
        if let gid = self.gid_1 {
            result = "\(gid)"
        }
        if let gid = self.gid_2 {
            result = "\(gid)"
        }
        return result
    }

    public var latitude: Double
    public var longitude: Double
    public var country: String?
    public var engType_1: String?
    public var engType_2: String?
    public var gid_0: String?
    public var gid_1: String?
    public var gid_2: String?
    public var hasc_1: String?
    public var hasc_2: String?
    public var name_0: String?
    public var name_1: String?
    public var name_2: String?
    public var nl_name_1: String?
    public var nl_name_2: String?
    public var type_0: String?
    public var type_1: String?
    public var type_2: String?
    public var varname_1: String?
    public var varname_2: String?
    public var coordinates: [[Double]]?
    
    
    //MARK: - functions
    public init(
        latitude: Double,
        longitude: Double,
        country: String?,
        engType_1: String?,
        engType_2: String?,
        gid_0: String?,
        gid_1: String?,
        gid_2: String?,
        hasc_1: String?,
        hasc_2: String?,
        name_0: String?,
        name_1: String?,
        name_2: String?,
        nl_name_1: String?,
        nl_name_2: String?,
        type_0: String?,
        type_1: String?,
        type_2: String?,
        varname_1: String?,
        varname_2: String?,
        coordinates: [[Double]]?
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.engType_1 = engType_1
        self.engType_2 = engType_2
        self.gid_0 = gid_0
        self.gid_1 = gid_1
        self.gid_2 = gid_2
        self.hasc_1 = hasc_1
        self.hasc_2 = hasc_2
        self.name_0 = name_0
        self.name_1 = name_1
        self.name_2 = name_2
        self.nl_name_1 = nl_name_1
        self.nl_name_2 = nl_name_2
        self.type_0 = type_0
        self.type_1 = type_1
        self.varname_1 = varname_1
        self.varname_2 = varname_2
        self.coordinates = coordinates
    }

    public static func fromMO(_ mo: MO) -> BlrDTO? {
        
        var geos: [[Double]] = [[]]
        
        if let coordinates = mo.coordinates {
            for (_, item) in coordinates.enumerated() {
                if let coord: [Double] = item as? [Double] {
                    geos.append(coord)
                }
            }
        }
        
        return BlrDTO(
            latitude: mo.latitude,
            longitude: mo.longitude,
            country: mo.country,
            engType_1: mo.engType_1,
            engType_2: nil,
            gid_0: mo.gid_0,
            gid_1: mo.gid_1,
            gid_2: mo.gid_2,
            hasc_1: mo.hasc_1,
            hasc_2: mo.hasc_2,
            name_0: mo.name_0,
            name_1: mo.name_1,
            name_2: mo.name_2,
            nl_name_1: mo.nl_name_1,
            nl_name_2: mo.nl_name_2,
            type_0: mo.type_0,
            type_1: mo.type_1,
            type_2: mo.type_2,
            varname_1: mo.varname_1,
            varname_2: mo.varname_2,
            coordinates: geos
        )
    }
    
    public func createMO(context: NSManagedObjectContext) -> BlrMO? {
        let mo = BlrMO(context: context)
        mo.apply(dto: self)
        return mo
    }

}
