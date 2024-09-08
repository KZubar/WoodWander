////
////  MapPlanPointsVM.swift
////  WoodWander
////
////  Created by k.zubar on 27.06.24.
////
//
//import UIKit
//import MapKit
//import Storage
//import StorageBLR
//
//
//protocol MapPlanPointsCoordinatorProtocol: AnyObject { }
//
//protocol MapPlanPointsMKMapViewServiceUseCase {
//    func getRadiusImage(region: MKCoordinateRegion) -> CLLocationDistance
//    func getRegionInMeters(region: MKCoordinateRegion) -> (x: Double, y: Double)
//    
//    func distanceTo(
//        point locationCoordinate: CLLocationCoordinate2D,
//        user userCoordinate: CLLocationCoordinate2D
//    ) -> Double
//    
//    func getMapRectByPoint(
//        mapView: MKMapView,
//        point: CGPoint,
//        sizeAnnotation: CGSize,
//        addToSize: Double,
//        mapBounds: CGRect
//    ) -> MKMapRect
//}
//
//protocol MapPlanPointsBlrDataWorkerUseCase {
//    func fetch(
//        predicate: NSPredicate?,
//        sortDescriptors: [NSSortDescriptor]
//    ) -> [any DTODescriptionBLR]
//}
//
//protocol MapPlanPointsFRCServiceUseCase {
//    var fetcherDTOs: [any DTODescriptionPlanPoint] { get }
//    var didChangeContent: (([any DTODescriptionPlanPoint]) -> Void)? { get set }
//    func startHandle()
//}
//
//protocol MapPlanPointsAlertServiceUseCase {
//    typealias AlertActionHandler = () -> Void
//    
//    func showAlertSettings(title: String?,
//                           message: String?,
//                           cancelTitle: String?,
//                           cancelHandler: AlertActionHandler?,
//                           settingsTitle: String?,
//                           settingsHandler: AlertActionHandler?,
//                           url: URL?)
//}
//
//protocol MapPlanPointsLocationHelperUseCase {
//    typealias AlertActionHandler = () -> Void
//    
//    var showMessageEnableGeoLocationHandler: AlertActionHandler? { get set }
//    var showMessageEnableLocationHandler: AlertActionHandler? { get set }
//    
//    func checkAutorization(status: CLAuthorizationStatus)
//    func getUserLocation() -> CLLocationCoordinate2D?
//}
//
//
//final class MapPlanPointsVM: MapPlanPointsViewModelProtocol, LocationHelperDelegate {
//
//    private enum Const {
//        static let regionInMetersDefault: Double = 200000
//    }
//    
//    typealias AlertActionHandler = () -> Void
//
//    private var frcService: MapPlanPointsFRCServiceUseCase
//    private var blrDataWorker: MapPlanPointsBlrDataWorkerUseCase
//    private weak var coordinator: MapPlanPointsCoordinatorProtocol?
//    private let alertService: MapPlanPointsAlertServiceUseCase
//    private let mapService: MapPlanPointsMKMapViewServiceUseCase
//
//    private let locationHelper: LocationHelper?
//    private var lastPointAnnotation: MKAnnotation?
//    
//    
//    init(coordinator: MapPlanPointsCoordinatorProtocol,
//         frcService: MapPlanPointsFRCServiceUseCase,
//         blrDataWorker: MapPlanPointsBlrDataWorkerUseCase,
//         mapService: MapPlanPointsMKMapViewServiceUseCase,
//         alertService: MapPlanPointsAlertServiceUseCase) {
//
//        self.coordinator = coordinator
//        self.frcService = frcService
//        self.blrDataWorker = blrDataWorker
//        self.alertService = alertService
//        self.mapService = mapService
//
//        self.locationHelper = LocationHelper()
//        //self.locationHelper?.locationManager?.startUpdatingLocation()
//        self.locationHelper?.delegate = self
//        
//        bind()
//    }
//
//    func viewDidLoad(mapView: MKMapView) {
//        self.locationHelper?.checkLocationEnabled()
//        self.setUserRegion(mapView: mapView)
//        self.addAnnotations(mapView: mapView)
//    }
//
//    func registerLocationAnnotation(mapView: MKMapView) {
//        
//        //Annotation, который карта может создать автоматически
//        mapView.register(LocationPinView.self,
//                         forAnnotationViewWithReuseIdentifier:
//                            "\(LocationPinView.self)")
//        
//        //по умолчанию для видов аннотаций вашей карты.
//        mapView.register(LocationMarkerView.self,
//                         forAnnotationViewWithReuseIdentifier:
//                            MKMapViewDefaultAnnotationViewReuseIdentifier)
//
//        //по умолчанию для представления аннотаций, представляющего группу аннотаций.
//        mapView.register(LocationClusterView.self,
//                         forAnnotationViewWithReuseIdentifier:
//                            MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
//    }
//    
//    func setUserRegion(mapView: MKMapView) {
//        guard let userRegion = getUserCoordinateRegion() else { return }
//        let region = mapView.regionThatFits(userRegion)
//        mapView.setRegion(region, animated: true)
//    }
//    
//    func getUserLocation() -> CLLocationCoordinate2D? {
//        return locationHelper?.getUserLocation()
//    }
//    
//    func distanceTo(locationCoordinate: CLLocationCoordinate2D) -> Double {
//        let userLoc = locationHelper?.getUserLocation()
//        
//        var distance: Double = 0
//        if let userCoord = userLoc {
//            distance = mapService.distanceTo(point: locationCoordinate, user: userCoord)
//        }
//        return distance
//    }
//    
//    func initTapPoint(mapView: MKMapView, point: CGPoint) -> CLLocationCoordinate2D? {
//        
//        //get point on MapKit
//        let tapPoint: CLLocationCoordinate2D = mapView.convert(
//            point,
//            toCoordinateFrom: mapView
//        )
//        
//        //delete annotation
//        if let pin = self.lastPointAnnotation {
//            mapView.removeAnnotation(pin)
//            self.lastPointAnnotation = nil
//        }
//        
//        //save annotation
//        self.lastPointAnnotation = LocationPin(
//            coordinate: tapPoint,
//            title: "title",
//            subtitle: "subtitle"
//        )
//        
//        //add new annotation
//        guard
//            let pin = self.lastPointAnnotation
//        else { return nil }
//        
//        mapView.addAnnotation(pin)
//        
//        return tapPoint
//    }
//    
//    func removeLastPointAnnotation(mapView: MKMapView) {
//        //delete annotation
//        if let pin = self.lastPointAnnotation {
//            mapView.removeAnnotation(pin)
//            self.lastPointAnnotation = nil
//        }
//    }
//    
//    func isAnnotationInArea(
//        mapView: MKMapView,
//        point: CGPoint,
//        sizeAnnotation: CGSize,
//        addToSize: Double,
//        mapBounds: CGRect
//    ) -> Bool {
//        let rect = mapService.getMapRectByPoint(
//            mapView: mapView,
//            point: point,
//            sizeAnnotation: sizeAnnotation,
//            addToSize: addToSize,
//            mapBounds: mapBounds
//        )
//        return (mapView.annotations(in: rect).count > 0)
//    }
//
//
//}
//
//
//
////MARK: - Private Function
//
//extension MapPlanPointsVM {
//    
//    private func bind() {
//        bindAlert()
//    }
//    
//    private func getUserCoordinateRegion() -> MKCoordinateRegion? {
//        guard let userLoc = locationHelper?.getUserLocation() else { return nil }
//        let userCoord = CLLocationCoordinate2D(latitude: userLoc.latitude,
//                                               longitude: userLoc.longitude)
//        return MKCoordinateRegion(center: userCoord,
//                                  latitudinalMeters: Const.regionInMetersDefault,
//                                  longitudinalMeters: Const.regionInMetersDefault)
//    }
//    
//    
//    private func addAnnotations(mapView: MKMapView) {
//        frcService.startHandle()
//        var dtos = frcService.fetcherDTOs
//        
//        //FIXME: - delete
//        
////        let dto1: PlanPointDTO = .init(uuid: UUID().uuidString,
////                                      date: Date(),
////                                      latitude: 53.97599980780105,
////                                      longitude: 27.391449826296686,
////                                      name: "Name_1",
////                                      descr: "Decr_2",
////                                      isDisabled: false,
////                                      oblast: "Obast_2",
////                                      region: "Region_2",
////                                      regionInMeters: 200000,
////                                      radiusInMeters: 1000.0,
////                                      imagePathStr: nil)
////        let dto2: PlanPointDTO = .init(uuid: UUID().uuidString,
////                                      date: Date(),
////                                      latitude: 53.87599980780105,
////                                      longitude: 27.291449826296686,
////                                      name: "Name_2",
////                                      descr: "Decr_2",
////                                      isDisabled: false,
////                                      oblast: "Obast_2",
////                                      region: "region_2",
////                                      regionInMeters: 200000,
////                                      radiusInMeters: 1000.0,
////                                      imagePathStr: nil)
////        dtos.append(dto1)
////        dtos.append(dto2)
//
//        var blrDtos = blrDataWorker.fetch(predicate: .BLR.all1, sortDescriptors: [])
//        
//        blrDtos.forEach { item in
//            let dto: PlanPointDTO = .init(uuid: UUID().uuidString,
//                                          date: Date(),
//                                          latitude: item.latitude,
//                                          longitude: item.longitude,
//                                          name: item.name_0,
//                                          descr: item.name_1,
//                                          isDisabled: false,
//                                          oblast: "Obast_2",
//                                          region: "Region_2",
//                                          regionInMeters: 200000,
//                                          radiusInMeters: 1000.0,
//                                          imagePathStr: nil)
//            dtos.append(dto)
//        }
//
//        ///.filter { $0 is LocationNotificationDTO }
//        let locPins = dtos.compactMap { dto in
//            if let dtoLoc = dto as? PlanPointDTO {
//                return LocationPin(coordinate: .init(latitude: dtoLoc.latitude,
//                                                     longitude: dtoLoc.longitude),
//                                   title: dtoLoc.name,
//                                   subtitle: dtoLoc.descr)
//            } else {
//                return nil
//            }
//        }
//        mapView.addAnnotations(locPins)
//    }
//    
//}
//
////MARK: - Alert Functions
//
//extension MapPlanPointsVM {
//    
//    private func bindAlert() {
//        locationHelper?.showMessageEnableGeoLocationHandler = { [weak self] in
//            //FIXME: - тест кложуров
//            let cancelH: AlertActionHandler = {
//                print("cancelH: ()->Void ")
//            }
//            let settingsH: AlertActionHandler = {
//                print("settingsH: ()->Void ")
//            }
//            self?.alertService.showAlertSettings(
//                title: "Установлен запрет на использвоание местоположения",
//                message: "Хотите это изменить?",
//                cancelTitle: "Закрыть",
//                cancelHandler: cancelH,
//                settingsTitle: "Настройки",
//                settingsHandler: settingsH,
//                url: URL(string: UIApplication.openSettingsURLString))
//        }
//        
//        locationHelper?.showMessageEnableLocationHandler = { [weak self] in
//            //FIXME: - тест кложуров
//            let cancelH: AlertActionHandler = {
//                print("cancelH: ()->Void ")
//            }
//            let settingsH: AlertActionHandler = {
//                print("settingsH: ()->Void ")
//            }
//            self?.alertService.showAlertSettings(
//                title: "У вас выключена служба геолокации",
//                message: "Хотите включить?",
//                cancelTitle: "Закрыть",
//                cancelHandler: cancelH,
//                settingsTitle: "Настройки",
//                settingsHandler: settingsH,
//                url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
//        }
//    }
//}
