//
//  LocationPinByTap.swift
//  WoodWander
//
//  Created by k.zubar on 8.09.24.
//

import MapKit

final class LocationPinByTap: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var isTapPin: Bool = false
    var uuid: String
    var param: LocationPinParameters = .big
    var color: String?
    var icon: String?

    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil,
         subtitle: String? = nil,
         uuid: String = "",
         color: String?,
         icon: String?,
         param: LocationPinParameters = .big,
         isTapPin: Bool = false
    ) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.uuid = uuid
        self.color = color
        self.icon = icon
        self.param = param

        super.init()
    }
    
}
