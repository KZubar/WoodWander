////
////  MapPlanPointsViewModelProtocol.swift
////  WoodWander
////
////  Created by k.zubar on 27.06.24.
////
//
//import MapKit
//
//protocol MapPlanPointsViewModelProtocol {
//
//    func registerLocationAnnotation(mapView: MKMapView)
//    
//    func removeLastPointAnnotation(mapView: MKMapView)
//    
//    func initTapPoint(
//        mapView: MKMapView,
//        point: CGPoint
//    ) -> CLLocationCoordinate2D?
//    
//    func isAnnotationInArea(
//        mapView: MKMapView,
//        point: CGPoint,
//        sizeAnnotation: CGSize,
//        addToSize: Double,
//        mapBounds: CGRect
//    ) -> Bool
//    
//    func getUserLocation() -> CLLocationCoordinate2D?
//    
//    func distanceTo(locationCoordinate: CLLocationCoordinate2D) -> Double
//    
//    func setUserRegion(mapView: MKMapView)
//    
//    func viewDidLoad(mapView: MKMapView)
//
//}
