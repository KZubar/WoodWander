//
//  MapPlanPointsViewModelProtocol.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import MapKit
import Storage

protocol MapPlanPointsViewModelProtocol {

    var addNewAnnotations: [LocationPin] { get set }
    
    var addNewPointByMap: ((_ annotation: (any MKAnnotation)?) -> Void)? { get set }

    var tapPointCoordinate: CLLocationCoordinate2D {get set}
    var tapPointDescription: PlanPointDescription? {get set}
    var pointDtos: [any DTODescriptionPlanPoint] {get set}
    var distance: Double {get set}
    
    func registerLocationAnnotation(mapView: MKMapView)
    
    func removeLastPointAnnotation(mapView: MKMapView)
    
    func changeSizeMarker(param: LocationPinParameters, mapView: MKMapView)
    
//перевел в приват
//    func initTapPoint(mapView: MKMapView, point: CGPoint) -> CLLocationCoordinate2D?
    
//перевел в приват
//    func isAnnotationInArea(mapView: MKMapView, point: CGPoint, sizeAnnotation: CGSize, addToSize: Double) -> Bool
    
    func getUserLocation() -> CLLocationCoordinate2D?
    
    func getParamForRegion(mapView: MKMapView) -> LocationPinParameters
    
    func distanceTo(locationCoordinate: CLLocationCoordinate2D) -> Double
    
    func setUserRegion(mapView: MKMapView)
    
    func viewDidLoad(mapView: MKMapView)
    
    func startCreatePlanPointModule()

    func startCategoriesPointModule()
    
    func startIconModule()
    
    func mapViewHandleSingleTap(mapView: MKMapView, point: CGPoint) -> Bool
    
    //func color(forDensity density: Double) -> UIColor
}
