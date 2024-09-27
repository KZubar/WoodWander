//
//  MapPlanPointsViewModelProtocol.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import MapKit
import Storage

protocol MapPlanPointsViewModelProtocol {

    typealias CompletionHandler = (Bool) -> Void

    var tapPointCoordinate: CLLocationCoordinate2D {get set}
    var tapPointDescription: PlanPointDescription? {get set}
    
    var pointDtos: [any DTODescriptionPlanPoint] {get set}
    
    var distance: Double {get set}
    //можно удалить из протокола?
    var previousZoomScale: Double {get set}
    
    func removeLastPointAnnotation(mapView: MKMapView)
    
    func changeSizeMarker(param: LocationPinParameters, mapView: MKMapView)
    
    func getUserLocation() -> CLLocationCoordinate2D?
    func getCurrentRegionInMeters(mapView: MKMapView) -> CLLocationDistance
    func distanceTo(locationCoordinate: CLLocationCoordinate2D) -> Double
    func setUserRegion(mapView: MKMapView)
    func deletePoint(mapView: MKMapView)

    func viewDidLoad(mapView: MKMapView)
    func viewWillAppear(mapView: MKMapView)
    
    func startCreatePlanPointModule()
    func startCategoriesPointModule()
    func startIconModule()
    
    func mapViewHandleSingleTap(mapView: MKMapView, point: CGPoint) -> Bool
    func mapViewSearchPointByText(mapView: MKMapView,
                                  searchText: String?) -> CLLocationCoordinate2D?
    
    func mapViewAnnotationDidSelect(mapView: MKMapView, view: MKAnnotationView) -> Bool
    func mapViewAnnotationDidDeselect(mapView: MKMapView, view: MKAnnotationView)
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    
    func addAnnotations(mapView: MKMapView)
}
