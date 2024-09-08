//
//  UIMapKit+CLLocationManager.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import MapKit

extension CLLocationManager {
    
    func locationServicesEnabledThreadSafe(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let result = CLLocationManager.locationServicesEnabled()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
}
