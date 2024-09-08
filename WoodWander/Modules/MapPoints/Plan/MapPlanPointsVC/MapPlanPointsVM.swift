//
//  MapPlanPointsVM.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import UIKit
import MapKit
import Storage
import StorageBLR


protocol MapPlanPointsViewModelDelegat: AnyObject {
    func addNewPoint(point: (any DTODescriptionPlanPoint))
}


final class MapPlanPointsVM: MapPlanPointsViewModelProtocol, LocationHelperDelegate {
    
    private enum Const {
        static let regionInMetersDefault: Double = 100000
        static let regionInMeters3: Double = 3000
        static let regionInMeters40: Double = 40000
    }
    
    typealias AlertActionHandler = () -> Void
    
    private weak var coordinator: MapPlanPointsCoordinatorProtocol?
    private let frcServicePP: MapPlanPointsFRCServicePlanPointUseCase
    private let blrDataWorker: MapPlanPointsBlrDataWorkerUseCase
    private let alertService: MapPlanPointsAlertServiceUseCase
    private let mapService: MapPlanPointsMKMapViewServiceUseCase
    
    private let locationHelper: LocationHelper?
    private var lastPointAnnotation: LocationPinByTap?
    
    var pointDtos: [any DTODescriptionPlanPoint] = []
    var tapPointCoordinate: CLLocationCoordinate2D = .init(latitude: 0.0, longitude: 0.0)
    var tapPointDescription: PlanPointDescription?
    var addNewAnnotations: [LocationPin] = []
    var distance: Double = 0.0

    var addNewPointByMap: ((_ annotation: (any MKAnnotation)?) -> Void)?
    
    init(coordinator: MapPlanPointsCoordinatorProtocol,
         frcServicePP: MapPlanPointsFRCServicePlanPointUseCase,
         blrDataWorker: MapPlanPointsBlrDataWorkerUseCase,
         mapService: MapPlanPointsMKMapViewServiceUseCase,
         alertService: MapPlanPointsAlertServiceUseCase) {
        
        self.coordinator = coordinator
        self.frcServicePP = frcServicePP
        self.blrDataWorker = blrDataWorker
        self.alertService = alertService
        self.mapService = mapService
        
        self.locationHelper = LocationHelper()
        //self.locationHelper?.locationManager?.startUpdatingLocation()
        self.locationHelper?.delegate = self
        
        bind()
    }
    
    func viewDidLoad(mapView: MKMapView) {
        self.locationHelper?.checkLocationEnabled()
        self.setUserRegion(mapView: mapView)
        self.addAnnotations(mapView: mapView)
    }
    
    func registerLocationAnnotation(mapView: MKMapView) {
        
        //Annotation, который карта может создать автоматически
        mapView.register(LocationPinView.self,
                         forAnnotationViewWithReuseIdentifier:
                            "\(LocationPinView.self)")
        
        //по умолчанию для видов аннотаций вашей карты.
        mapView.register(LocationMarkerView.self,
                         forAnnotationViewWithReuseIdentifier:
                            MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //по умолчанию для представления аннотаций, представляющего группу аннотаций.
        mapView.register(LocationClusterView.self,
                         forAnnotationViewWithReuseIdentifier:
                            MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    //установить регион юзера
    func setUserRegion(mapView: MKMapView) {
        let latitudeDelta = mapView.region.span.latitudeDelta
        guard let userRegion = getUserCoordinateRegion(latitudeDelta) else { return }
        let region = mapView.regionThatFits(userRegion)
        mapView.setRegion(region, animated: true)
    }
    
    //получить локацию юзера
    func getUserLocation() -> CLLocationCoordinate2D? {
        return locationHelper?.getUserLocation()
    }
    
    //поучить дистанцию до локации
    func distanceTo(locationCoordinate: CLLocationCoordinate2D) -> Double {
        let userLoc = locationHelper?.getUserLocation()
        
        var distance: Double = 0
        if let userCoord = userLoc {
            distance = mapService.distanceByFormulaTo(point: locationCoordinate, user: userCoord)
        }
        return distance
    }
   
    //удалим последний аннотацию являющуюся последним тапом юзера по карте
    func removeLastPointAnnotation(mapView: MKMapView) {
        self.tapPointCoordinate = .init(latitude: 0.0, longitude: 0.0)
        self.tapPointDescription = nil
        self.distance = 0.0
        if let pin = self.lastPointAnnotation {
            mapView.removeAnnotation(pin)
            self.lastPointAnnotation = nil
        }
    }
    
    //размер размеры маркеров на карте
    func changeSizeMarker(param: LocationPinParameters, mapView: MKMapView) {
        let annotations = mapView.annotations.compactMap { $0 as? LocationPin }
        mapView.removeAnnotations(annotations)
        annotations.forEach { marker in
            if !marker.isTapPin { marker.param = param }
        }
        mapView.addAnnotations(annotations)
    }
    
    //открывает экран создания-редактирования точки
    func startCreatePlanPointModule() {
        self.tapPointDescription = PlanPointDescription(latitude: self.tapPointCoordinate.latitude,
                                                        longitude: self.tapPointCoordinate.longitude)
        if let point = self.tapPointDescription {
            coordinator?.startCreatePlanPointModule(delegate: self, point: point)
        }
    }
    
    
    //открывает экран создания точки с выбором в списка
    func startCategoriesPointModule() {
        self.tapPointDescription = PlanPointDescription(latitude: self.tapPointCoordinate.latitude,
                                                        longitude: self.tapPointCoordinate.longitude)
        if let point = self.tapPointDescription {
            coordinator?.startCategoriesPointModule(delegate: self, point: point)
        }
    }
    
    //открывает экран промотра всех иконок модуля
    func startIconModule() {
        coordinator?.startIconModule()
    }
    
    //возвращает структуру параметров для текущего масштаба карты
    func getParamForRegion(mapView: MKMapView) -> LocationPinParameters {
        return mapService.getParamForRegion(mapView: mapView)
    }
    
    //обрабатывает одиночный тап по карте, проверяет и  настраивает
    func mapViewHandleSingleTap(mapView: MKMapView, point: CGPoint) -> Bool {
        let param = getParamForRegion(mapView: mapView)
        let sizeAnnotation: CGSize = param.sizeRenderer
        let addToSize: Double = param.addToSizeRenderer
        
        //каждое нажатие на карту проверяем наличие аннотаций для добавления на карту
        if addNewAnnotations.count > 0 {
            addNewAnnotations.forEach { mapView.addAnnotation($0) }
            addNewAnnotations.removeAll()
        }
        
        //попали в Annotation или нет
        if isAnnotationInArea(mapView: mapView, point: point, sizeAnnotation: sizeAnnotation, addToSize: addToSize) {
            return false
        }

        guard let tapPoint = initTapPoint(mapView: mapView, point: point) else { return false}
        
        self.tapPointCoordinate = tapPoint
        self.tapPointDescription = PlanPointDescription(latitude: tapPoint.latitude,
                                                        longitude: tapPoint.longitude)
        self.distance = distanceTo(locationCoordinate: tapPoint)

        return true
    }
    
}

extension MapPlanPointsVM: MapPlanPointsViewModelDelegat {
    //когда точка была создана добавляет ее на карту
    func addNewPoint(point: (any DTODescriptionPlanPoint)) {
        self.tapPointDescription = PlanPointDescription.fromDTO(point)
        self.pointDtos.append(point)
        let annotation = LocationPin(coordinate: .init(latitude: point.latitude,
                                                       longitude: point.longitude),
                                     title: point.name,
                                     subtitle: point.descr,
                                     uuid: point.uuid,
                                     color: point.color,
                                     icon: point.icon)
        self.addNewAnnotations.append(annotation)
    }
}

//MARK: - Private Function

extension MapPlanPointsVM {
    
    private func bind() { }
    
    //создадим аннотацию на карте по таппу юзера
    private func initTapPoint(mapView: MKMapView, point: CGPoint) -> CLLocationCoordinate2D? {
        //получаем точку на карте в системе координат MapKit
        let tapPoint: CLLocationCoordinate2D = mapView.convert(point,
                                                               toCoordinateFrom: mapView)
        //удаляем на карте последнюю аннотацию, если она была создана
        self.removeLastPointAnnotation(mapView: mapView)
        //создаем пустую аннотацию с координатами tapPoint
        self.lastPointAnnotation = LocationPinByTap(coordinate: tapPoint,
                                                    title: "новая точка",
                                                    subtitle: "subtitle",
                                                    uuid: "",
                                                    color: "",
                                                    icon: "",
                                                    param: .big,
                                                    isTapPin: true)
        //избавимся от опционала
        guard let pin = self.lastPointAnnotation else { return nil }
        //добавим на карту
        mapView.addAnnotation(pin)
        //вернем координаты в системе координат MapKit
        return tapPoint
    }

    //проверяет наличие аннотации в заданном квадрате
    private func isAnnotationInArea(mapView: MKMapView, point: CGPoint, sizeAnnotation: CGSize, addToSize: Double) -> Bool {
        let rect = mapService.getMapRectByPoint(mapView: mapView,
                                                point: point,
                                                sizeAnnotation: sizeAnnotation,
                                                addToSize: addToSize)
        return (mapView.annotations(in: rect).count > 0)
    }

    //устанавливает регион пользователя
    private func getUserCoordinateRegion(_ latitudeDelta: Double = 0) -> MKCoordinateRegion? {
        guard let userLoc = locationHelper?.getUserLocation() else { return nil }
 
        //это параметры для установки региона для видимости РБ
//        MKCoordinateRegion
//          ▿ center : CLLocationCoordinate2D
//            - latitude : 53.34165600000002
//            - longitude : 28.023665999999977
//          ▿ span : MKCoordinateSpan
//            - latitudeDelta : 11.415133584516497
//            - longitudeDelta : 9.758302000000068
        
        
        let userCoord = CLLocationCoordinate2D(latitude: userLoc.latitude,
                                               longitude: userLoc.longitude)
        var regionInMeters: Double = Const.regionInMetersDefault
        
        if latitudeDelta > 2.0 && latitudeDelta <= 10.0 {
            regionInMeters = Const.regionInMeters40
        } else if latitudeDelta > 0.0 && latitudeDelta <= 2.0 {
            regionInMeters = Const.regionInMeters3
        }
        return MKCoordinateRegion(center: userCoord,
                                  latitudinalMeters: regionInMeters,
                                  longitudinalMeters: regionInMeters)
    }
    
    //добавляем аннотации юзера на карту
    private func addAnnotations(mapView: MKMapView) {
        frcServicePP.startHandle()
        
        self.pointDtos = frcServicePP.fetcherDTOs
        
        let locPins = self.pointDtos.compactMap { dto in
            if let dtoLoc = dto as? PlanPointDTO {
                //зачем это тут если не используется???
                //let point = PlanPointDescription.fromDTO(dtoLoc)
                return LocationPin(coordinate: .init(latitude: dtoLoc.latitude,
                                                     longitude: dtoLoc.longitude),
                                   title: dtoLoc.name,
                                   subtitle: dtoLoc.descr,
                                   uuid: dtoLoc.uuid,
                                   color: dtoLoc.color,
                                   icon: dtoLoc.icon)
            } else {
                return nil
            }
        }
        mapView.addAnnotations(locPins)
        //addHeatmap(mapView: mapView, locPins: locPins)
    }
    
}
