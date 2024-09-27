//
//  PlanPointDescription.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import Storage

public struct PlanPointDescription {

    public var uuid: String
    public var date: Date?
    public var latitude: Double
    public var longitude: Double
    public var name: String?
    public var descr: String?
    public var isDisabled: Bool
    
    public var oblast: String?
    public var region: String?
    public var color: String?
    public var icon: String?
    public var imagePathStr: String?
    public var radiusInMeters: Double
    public var regionInMeters: Double

    public init(
        uuid: String,
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
        color: String?,
        icon: String?,
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
        self.color = color
        self.icon = icon
        self.imagePathStr = imagePathStr
        self.radiusInMeters = radiusInMeters
        self.regionInMeters = regionInMeters
    }

    public init(latitude: Double = 0.0, longitude: Double = 0.0) {
        self.uuid = ""
        self.date = nil
        self.latitude = latitude
        self.longitude = longitude
        self.name = ""
        self.descr = ""
        self.isDisabled = false
        
        self.oblast = nil
        self.region = nil
        self.color = nil
        self.imagePathStr = nil
        self.radiusInMeters = 0.0
        self.regionInMeters = 0.0
    }
    
    public static func fromDTO(_ dto: (any DTODescriptionPlanPoint)) -> PlanPointDescription? {
        return PlanPointDescription(uuid: dto.uuid,
                                    date: dto.date,
                                    latitude: dto.latitude,
                                    longitude: dto.longitude,
                                    name: dto.name,
                                    descr: dto.descr,
                                    isDisabled: dto.isDisabled,
                                    oblast: dto.oblast,
                                    region: dto.region,
                                    regionInMeters: dto.regionInMeters,
                                    radiusInMeters: dto.radiusInMeters,
                                    color: dto.color,
                                    icon: dto.icon,
                                    imagePathStr: dto.imagePathStr)
    }
}


extension PlanPointDescription: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public static func == (lhs: PlanPointDescription, rhs: PlanPointDescription) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}



