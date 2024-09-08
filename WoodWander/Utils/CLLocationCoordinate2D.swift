//
//  CLLocationCoordinate2D.swift
//  WoodWander
//
//  Created by k.zubar on 2.07.24.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    func stringLocationCoordinate2D(count: Int) -> String {
        let sLat = "\(latitude)".stringLeftCharacter(count: count)
        let sLon = "\(longitude)".stringLeftCharacter(count: count)
        return "\(sLat), \(sLon)"
    }
    
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
