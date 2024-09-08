//
//  LocationHelper.swift
//  WoodWander
//
//  Created by k.zubar on 1.07.24.
//

import CoreLocation
import UIKit

@objc protocol LocationHelperDelegate {
    @objc optional func locationHelper(
        _ helper: LocationHelper,
        didUpdateLocations locations: [CLLocation]
    )
    @objc optional func locationHelper(
        _ helper: LocationHelper,
        didFailWithError error: Error
    )
}

class LocationHelper: NSObject {
    
    typealias AlertActionHandler = () -> Void
    
    var locationManager: CLLocationManager?
    
    weak var delegate: LocationHelperDelegate?
    
    var didUpdateLocations: (([CLLocation]) -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    var showMessageEnableGeoLocationHandler: AlertActionHandler?
    var showMessageEnableLocationHandler: AlertActionHandler?
    
    override init() {
        super.init()
    }
    
    private func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    func checkAutorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager?.startUpdatingLocation()
            break
        case .denied:
            self.showMessageEnableGeoLocationHandler?()
            break
        case .restricted:
            break
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func checkLocationEnabled() {
        CLLocationManager().locationServicesEnabledThreadSafe { [weak self] areEnabled in
            if areEnabled {
                self?.setupLocationManager()
            } else {
                self?.showMessageEnableLocationHandler?()
            }
        }
    }
    
    func getUserLocation() -> CLLocationCoordinate2D? {
        if let location = locationManager?.location?.coordinate {
            return location
        }
        return nil
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationHelper: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAutorization(status: manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationHelper?(self, didUpdateLocations: locations)
        didUpdateLocations?(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationHelper?(self, didFailWithError: error)
        didFailWithError?(error)
    }
    
}
