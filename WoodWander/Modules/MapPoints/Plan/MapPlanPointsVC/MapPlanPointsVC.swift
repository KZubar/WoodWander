//
//  MapPlanPointsVC.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import SwiftIcons


final class MapPlanPointsVC: UIViewController {

    private enum ConstButton {
        static let myGpsSize: Double = 45.0
        static let cancelHeight: Double = 45.0
    }

    private enum Icon {
        static let nearMe: FontType = UIImage.Map.nearMe
    }

    //TODO: - variables
    private var isSelectedAnnotation: Bool = false
    
    private var viewModel: MapPlanPointsViewModelProtocol
    
    private var paramLocationPin: LocationPinParameters = .big {
        didSet {
            //надо изменить размер картинки
            viewModel.changeSizeMarker(param: paramLocationPin, mapView: mapView)
        }
    }

    //TODO: - UI elemets
    private lazy var contentView: UIView = .setContentView()

    private lazy var newPlaceView: NewPlaceDescriptionView = {
        let view = NewPlaceDescriptionView()
        view.delegat = self
        view.isHidden = true
        return view
    }()
    
    private lazy var userRegionButton: UIButton = {
        let bttn = UIButton()
        bttn.backgroundColor = .appWhite
        bttn.setIcon(icon: Icon.nearMe,
                     iconSize: 20,
                     color: .appBlue,
                     backgroundColor: .appWhite,
                     forState: .normal)
        bttn.setBorder(width: 0.25, color: .appBlue)
        bttn.setShadow()
        bttn.cornerRadius = ConstButton.myGpsSize / 2
        return bttn
    }().withAction(self, #selector(userRegionButtonDidTap), for: .touchUpInside)

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self

        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true

        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.showsBuildings = true
        
        mapView.mapType = .hybrid //.standard

//        if #available(iOS 17.0, *) {
//            mapView.showsUserTrackingButton = true
//        }
        
        return mapView
    }()

    //TODO: - init()
    init(viewModel: MapPlanPointsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(Self.self) was called by coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //регистрация маркеров, кластеров, вьюшек на карте
        viewModel.registerLocationAnnotation(mapView: mapView)
        
        // одиночное нажатие на карту
        let singleTapMap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(mapViewHandleSingleTap(recognizer:))
        )
        singleTapMap.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(singleTapMap)

        // двойное нажатие на карту
        let doubleTapMap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(mapViewHandleDoubleTap(recognizer:))
        )
        doubleTapMap.numberOfTapsRequired = 2
        self.mapView.addGestureRecognizer(doubleTapMap)
        
        //Создает зависимость между средством распознавания жестов
        //  и другим средством распознавания жестов при создании объектов
        singleTapMap.require(toFail: doubleTapMap)
        
        //задерживает ли распознаватель жестов отправку касаний
        //  на начальной фазе в свой режим просмотра.
        singleTapMap.delaysTouchesBegan = true
        doubleTapMap.delaysTouchesBegan = true
    }
    
    private func bind() {

        //настойка viewModel
        viewModel.viewDidLoad(mapView: mapView)

        //        //FIXME: - delete
//        let dataSourse = EventDataSourse()
//        mapView.addOverlays(dataSourse.overlays)
//        mapView.addAnnotations(dataSourse.annotation)
    }

    private func setupUI() {
        self.view.backgroundColor = .appWhite
        
        self.view.addSubview(contentView)
        self.view.addSubview(userRegionButton) //FIXME: где картинка делась?
 
        self.contentView.addSubview(mapView)
        self.contentView.addSubview(newPlaceView)

    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            //make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        userRegionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(175)
            make.size.equalTo(ConstButton.myGpsSize)
        }
        newPlaceView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(-8)
            //make.bottom.equalToSuperview().inset(-16)
            //make.height.equalTo(100)
        }
    }

    //TODO: - @objc private func
    //при нажатии устанавливаем регион пользователя с нужным массшабом карты
    @objc private func userRegionButtonDidTap(_ sender: UIButton) {
        viewModel.setUserRegion(mapView: mapView)
    }
    
    //двойное нажатие пока не отрабатываем
    @objc private func mapViewHandleDoubleTap(recognizer: UITapGestureRecognizer) {}

    //при нажатии на карту показываем точку и показываем меню
    @objc private func mapViewHandleSingleTap(recognizer: UITapGestureRecognizer) {
        if self.isSelectedAnnotation { return }
        if recognizer.state == .ended {
            //точка в координатах экрана
            let point = recognizer.location(in: mapView)
            //покажем вьюшку с кнопками
            if viewModel.mapViewHandleSingleTap(mapView: mapView, point: point) {
                self.newPlaceView.setInfo(point: viewModel.tapPointCoordinate,
                                          distance: viewModel.distance)
                self.newPlaceView.isHidden = false
            }
        }
    }

}

extension MapPlanPointsVC: MKMapViewDelegate {

    //Вызывается для каждой "аннотации" (маркера) перед ее отображением на экране.
    //  - возвращает: представление, представляющее маркер.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let marker = annotation as? LocationPin {
            let pinView: LocationPinView = mapView.dequeue()
                pinView.annotation = marker
                pinView.setupIcon()
                return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let param = viewModel.getParamForRegion(mapView: mapView)
        if param != self.paramLocationPin {
            self.paramLocationPin = param
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.isSelectedAnnotation = true
        view.isSelected = true

//        switch view {
//        case is LocationPin:
//            //
//            break
//        case is LocationMarkerView:
//            //
//            break
//        default:
//            //
//            break
//        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.isSelectedAnnotation = false
        view.isSelected = false
    }
        
//    func mapView(
//        _ mapView: MKMapView,
//        annotationView view: MKAnnotationView,
//        didChange newState: MKAnnotationView.DragState,
//        fromOldState oldState: MKAnnotationView.DragState
//    ) {
//        
//        let a = 1
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let multiPolygon = overlay as? MKMultiPolygon {
            let renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
            renderer.fillColor = UIColor.appBlueLight
            renderer.strokeColor = .appYellow
            renderer.lineWidth = 1.0
            return renderer
        }
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemRed
            renderer.lineWidth = 2
            return renderer
        }
//        if let circleOverlay = overlay as? MKCircle {
//            if let densityString = circleOverlay.title {
//                if let density = Double(densityString) {
//                    let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
//                    circleRenderer.fillColor = viewModel.color(forDensity: density)
//                    circleRenderer.strokeColor = viewModel.color(forDensity: density)
//                    circleRenderer.lineWidth = 1
//                    return circleRenderer
//                }
//            }
//        }

        return MKOverlayRenderer(overlay: overlay)
    }
    
}

extension MapPlanPointsVC: NewPlaceDescriptionViewPotocol {
    func removeLastPointAnnotation() {
        self.newPlaceView.isHidden = true
        viewModel.removeLastPointAnnotation(mapView: mapView)
    }
    func openCreatePlanPontVC() {
        viewModel.startCreatePlanPointModule()
    }
    func openCategoriesPointVC() {
        viewModel.startCategoriesPointModule()
    }
    func openIconViewVC() {
        viewModel.startIconModule()
    }
}
