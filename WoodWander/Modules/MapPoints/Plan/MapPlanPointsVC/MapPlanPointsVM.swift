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



final class MapPlanPointsVM: MapPlanPointsViewModelProtocol, LocationHelperDelegate {
    
    private enum Const {
        static let regionInMetersDefault: Double = 100000
        static let regionInMeters3: Double = 3000
        static let regionInMeters40: Double = 40000
    }
    
    typealias AlertActionHandler = () -> Void
    
    private weak var coordinator: MapPlanPointsCoordinatorProtocol?
    private let dataWorker: MapPlanPointsPlanPointDataWorkerUseCase
    private let mapService: MapPlanPointsMKMapViewServiceUseCase
    
    private let locationHelper: LocationHelper?
    private var lastPointAnnotation: LocationPinByTap?
    
    private var paramLocationPin: LocationPinParameters = .big

    var pointDtos: [any DTODescriptionPlanPoint] = []
    
    private var selectedPointDto: (any DTODescriptionPlanPoint)?

    var tapPointCoordinate: CLLocationCoordinate2D = .init(latitude: 0.0, longitude: 0.0)
    var tapPointDescription: PlanPointDescription?
    var distance: Double = 0.0
    var previousZoomScale: Double = 0
    
    init(
        coordinator: MapPlanPointsCoordinatorProtocol,
        dataWorker: MapPlanPointsPlanPointDataWorkerUseCase,
        mapService: MapPlanPointsMKMapViewServiceUseCase
    ) {
        
        self.coordinator = coordinator
        self.dataWorker = dataWorker
        self.mapService = mapService
        
        self.locationHelper = LocationHelper()
        //self.locationHelper?.locationManager?.startUpdatingLocation()
        self.locationHelper?.delegate = self
        
        bind()
    }
    
    func viewDidLoad(mapView: MKMapView) {
        self.locationHelper?.checkLocationEnabled()
        self.setUserRegion(mapView: mapView)
        self.previousZoomScale = mapService.getZoomScale(mapView: mapView)
        self.addAnnotations(mapView: mapView)
    }
    
    func viewWillAppear(mapView: MKMapView) {
        //регистрация маркеров, кластеров, вьюшек на карте
        self.registerLocationAnnotation(mapView: mapView)
    }
    
    private func registerLocationAnnotation(mapView: MKMapView) {
        
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
    
    //удаляем точку
    func deletePoint(mapView: MKMapView) {
        
        if let selectedDto = self.selectedPointDto {
            self.tapPointDescription = PlanPointDescription.fromDTO(selectedDto)
            self.dataWorker.deleteByUser(dto: selectedDto, completion: nil)
            
            //удалим из массиввов
                self.pointDtos.removeAll(where: { $0.uuid == selectedDto.uuid })

                let annotations = mapView.annotations
                    .compactMap { $0 as? LocationPin }
                    .compactMap { $0.uuid == selectedDto.uuid ? $0 : nil }
                
                mapView.removeAnnotations(annotations)
                
                self.tapPointCoordinate = .init(latitude: 0.0, longitude: 0.0)
                self.tapPointDescription = nil
                self.distance = 0.0
                self.lastPointAnnotation = nil
            
        }
        
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
            coordinator?.startCreatePlanPointModule(point: point)
        }
    }
    
    
    //открывает экран создания точки с выбором в списка
    func startCategoriesPointModule() {
        if let selectedDto = self.selectedPointDto {
            self.tapPointDescription = PlanPointDescription.fromDTO(selectedDto)
        } else {
            self.tapPointDescription = PlanPointDescription(latitude: self.tapPointCoordinate.latitude,
                                                            longitude: self.tapPointCoordinate.longitude)
            self.tapPointDescription?.date = Date()
            self.tapPointDescription?.uuid = UUID().uuidString
        }
        
        if let ptn = self.tapPointDescription {
            coordinator?.startCategoriesPointModule(point: ptn)
        }
    }
    
    //открывает экран промотра всех иконок модуля
    func startIconModule() {
        coordinator?.startIconModule()
    }
    
    //обрабатывает одиночный тап по карте, проверяет и  настраивает
    func mapViewHandleSingleTap(mapView: MKMapView, point: CGPoint) -> Bool {
        let sizeAnnotation: CGSize = self.paramLocationPin.sizeRenderer
        let addToSize: Double = self.paramLocationPin.addToSizeRenderer
 
        //попали в Annotation или нет
        if isAnnotationInArea(mapView: mapView,
                              point: point,
                              sizeAnnotation: sizeAnnotation,
                              addToSize: addToSize) {
            return false
        }

        guard
            let tapPoint = initTapPointByPoint(mapView: mapView,
                                                 point: point)
        else { return false}
        
        self.tapPointCoordinate = tapPoint
        self.tapPointDescription = PlanPointDescription(latitude: tapPoint.latitude,
                                                        longitude: tapPoint.longitude)
        self.distance = distanceTo(locationCoordinate: tapPoint)

        return true
    }
    
    //обрабатывает поиск на карте введенной точки
    func mapViewSearchPointByText(mapView: MKMapView, 
                                  searchText: String?) -> CLLocationCoordinate2D? {
        
        guard let searchText else { return nil }
        
        if searchText.isEmpty { return nil }
        
        guard
            let coordinate2D = mapService.convertToCoordinate2D(from: searchText)
        else { return nil }
        
        guard
            let searchPoint = initTapPointByCoordinate(mapView: mapView,
                                                       coordinate2D: coordinate2D)
        else { return nil }
        
        //настроим переменные
        self.tapPointCoordinate = searchPoint
        self.tapPointDescription = PlanPointDescription(latitude: searchPoint.latitude,
                                                        longitude: searchPoint.longitude)
        self.distance = distanceTo(locationCoordinate: searchPoint)
        
        //покинем функцию
        return searchPoint
    }

    //обрабатывает выбор аннотации на карте, проверяет и  настраивает
    func mapViewAnnotationDidSelect(mapView: MKMapView, view: MKAnnotationView) -> Bool {
        guard let locationPin = view.annotation as? LocationPin else { return false }
        
        //если на кате выбран LocationPin, то по uuid находит dto в массиве
        self.selectedPointDto = nil
        if locationPin.uuid.isEmpty { return false }
        if let index = self.pointDtos.firstIndex(
            where: { $0.uuid == locationPin.uuid }
        ) {
            self.selectedPointDto = self.pointDtos[index]
        }

        guard let dto = self.selectedPointDto else { return false }
        
        //удалим точку на карте, если юзер кликал по карте (новая точка)
        if let pin = self.lastPointAnnotation {
            mapView.removeAnnotation(pin)
            self.lastPointAnnotation = nil
        }

        let tapPoint = CLLocationCoordinate2D(latitude: dto.latitude,
                                              longitude: dto.longitude)
        self.tapPointCoordinate = tapPoint
        self.tapPointDescription = PlanPointDescription.fromDTO(dto)
        self.distance = distanceTo(locationCoordinate: tapPoint)

        return true
    }

    //обрабатывает отмену выборы аннотации на карте
    func mapViewAnnotationDidDeselect(mapView: MKMapView, view: MKAnnotationView) {
        
        if ((view.annotation as? LocationPin) != nil) {
            //если на кате выбран LocationPin, то по uuid находит dto в массиве
            self.selectedPointDto = nil
            self.tapPointCoordinate = .init(latitude: 0.0, longitude: 0.0)
            self.tapPointDescription = nil
            self.distance = 0.0
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //возвращает структуру параметров для текущего масштаба карты
        let param = self.mapService.getParamForRegion(mapView: mapView)
        
        if param != self.paramLocationPin {
            self.paramLocationPin = param
            changeSizeMarker(param: paramLocationPin, mapView: mapView)
        }
    }
    
}

//MARK: - Private Function

extension MapPlanPointsVM {
    
    private func bind() { }
    
    //создадим аннотацию на карте по таппу юзера
    private func initTapPointByPoint(mapView: MKMapView, point: CGPoint) -> CLLocationCoordinate2D? {
        //получаем точку на карте в системе координат MapKit
        let coordinate2D: CLLocationCoordinate2D = mapView.convert(point, toCoordinateFrom: mapView)
        return initTapPointByCoordinate(mapView: mapView, coordinate2D: coordinate2D)
    }
    
    //создадим аннотацию на карте по таппу юзера
    private func initTapPointByCoordinate(mapView: MKMapView, coordinate2D: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        //удаляем на карте последнюю аннотацию, если она была создана
        self.removeLastPointAnnotation(mapView: mapView)
        //создаем пустую аннотацию с координатами tapPoint
        self.lastPointAnnotation = LocationPinByTap(coordinate: coordinate2D,
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
        return coordinate2D
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
    
    func getCurrentRegionInMeters(mapView: MKMapView) -> CLLocationDistance {
        return mapService.getCurrentRegionInMeters(mapView: mapView)
    }
    
    //добавляем аннотации юзера на карту
    func addAnnotations(mapView: MKMapView) {
       
        let annotations = mapView.annotations.compactMap { $0 as? LocationPin }
        if annotations.count > 0 {
            mapView.removeAnnotations(annotations)
        }
        
        //получаем точки
        self.pointDtos = self.dataWorker.fetch(
            predicate: .Point.all,
            sortDescriptors: [.Point.byDate]
        )

        //получаем таблицу точки + списки
        let dtosPPCategories = self.dataWorker.fetchPPCategories(
            predicate: .PPCategories.allIsUsed,
            sortDescriptors: [.PPCategories.byUuidPoint]
        )
        
       
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
                                   icon: dtoLoc.icon,
                                   param: self.paramLocationPin)
            } else {
                return nil
            }
        }
        
        mapView.addAnnotations(locPins)
        //addHeatmap(mapView: mapView, locPins: locPins)
    }
    
}
