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

//        if Thread.isMainThread {
//            print("1 - Выполнение в main потоке")
//        } else {
//            print("1 - Выполнение в background потоке")
//        }


final class MapPlanPointsVC: UIViewController {

    private enum ConstButton {
        static let myGpsSize: Double = 45.0
        static let searchGeoHeight: Double = 45.0
        static let cancelHeight: Double = 45.0
    }

    private enum Icon {
        static let nearMe: FontType = UIImage.Map.nearMe
        static let deleteForever: FontType = UIImage.All.deleteForever
        static let locationSearching: FontType = UIImage.Map.locationSearching
        static let locationOn: FontType = UIImage.Map.locationOn

    }
    
    private enum ConstSearchGeoViewSize {
        static let viewHeight: Double = 45.0
        static let buttonHeight: Double = 35.0
        static let buttonCloseWidth: Double = 70.0
        static let distanceBetween: Double = 5.0
    }

    //TODO: - variables
    private var isSelectedAnnotation: Bool = false {
        didSet {
            self.pointDeleteButton.isHidden = !isSelectedAnnotation
        }
    }
    
    private var isExpandedSearchGeoView = false
    private var viewModel: MapPlanPointsViewModelProtocol

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
    
    private lazy var pointDeleteButton: UIButton = {
        let bttn = UIButton()
        bttn.backgroundColor = .appWhite
        bttn.isHidden = true
        bttn.setIcon(icon: Icon.locationOn,
                     iconSize: 20,
                     color: .appBlue,
                     backgroundColor: .appWhite,
                     forState: .normal)
        bttn.setBorder(width: 0.25, color: .appBlue)
        bttn.setShadow()
        bttn.cornerRadius = ConstButton.myGpsSize / 2
        return bttn
    }().withAction(self, #selector(pointDeleteButtonDidTap), for: .touchUpInside)
 
    private lazy var searchGeoView: SearchGeoView = {
        let view = SearchGeoView()
        view.delegat = self
        view.placeHolder = "Поиск по координатам"
        view.placeHolderColor = .defaultByMarker
        view.textColor = .mainFont
        view.cornerRadius = ConstButton.searchGeoHeight / 2
        return view
    }()
    
    private lazy var scaleView: MKScaleView = {
        let scale = MKScaleView(mapView: mapView)
        scale.translatesAutoresizingMaskIntoConstraints = false
        scale.scaleVisibility = .adaptive
        return scale
    }()
    
    
    
    
    
    
    
    
    
    
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self

        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true

        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.showsScale = false
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .updateCategory,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .updatePoint,
                                                  object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupConstraintsSearchGeoView()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear(mapView: mapView)

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
        
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(updateAllAnotations),
                                                   name: .updateCategory,
                                                   object: nil)
        
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(updateAnotation),
                                                   name: .updatePoint,
                                                   object: nil)

        self.searchGeoView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        self.isExpandedSearchGeoView = false

        //        //FIXME: - delete
//        let dataSourse = EventDataSourse()
//        mapView.addOverlays(dataSourse.overlays)
//        mapView.addAnnotations(dataSourse.annotation)
    }

    private func setupUI() {
        self.view.backgroundColor = .appWhite
        
        self.view.addSubview(contentView)
        self.view.addSubview(userRegionButton)
        self.view.addSubview(pointDeleteButton)
        self.view.addSubview(searchGeoView)
        self.view.addSubview(scaleView)
        
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
        scaleView.snp.makeConstraints { make in
            make.leading.equalTo(mapView).offset(8)
            make.top.equalTo(searchGeoView.snp.bottom).inset(-16)
        }
        
        userRegionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(175)
            make.size.equalTo(ConstButton.myGpsSize)
        }
        pointDeleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(self.userRegionButton.snp.top).inset(-20)
            make.size.equalTo(ConstButton.myGpsSize)
        }
        newPlaceView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(-8)
            //make.bottom.equalToSuperview().inset(-16)
            //make.height.equalTo(100)
        }
    }
    
    private func setupConstraintsSearchGeoView() {
        self.searchGeoView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8)
            make.height.equalTo(ConstSearchGeoViewSize.viewHeight)
            make.width.equalTo(ConstSearchGeoViewSize.viewHeight)
        }
    }

    //TODO: - @objc private func
    //при нажатии устанавливаем регион пользователя с нужным массшабом карты
    @objc private func userRegionButtonDidTap(_ sender: UIButton) {
        viewModel.setUserRegion(mapView: mapView)
    }
    //при нажатии устанавливаем регион пользователя с нужным массшабом карты
    @objc private func pointDeleteButtonDidTap(_ sender: UIButton) {
        viewModel.deletePoint(mapView: mapView)
    }
    
    //Добавление всех аннотаций (после редактирования категии, например при удалении категории)
    @objc private func updateAllAnotations(_ sender: UIButton) {
        viewModel.addAnnotations(mapView: mapView)
    }

    //FIXME:- добавление одной аанотации, например при редактировании или добавлении новой
    @objc private func updateAnotation(_ sender: UIButton) {
        viewModel.addAnnotations(mapView: mapView)
    }

    //двойное нажатие пока не отрабатываем
    @objc private func mapViewHandleDoubleTap(recognizer: UITapGestureRecognizer) {}

    //при нажатии на карту показываем точку и показываем меню
    @objc private func mapViewHandleSingleTap(recognizer: UITapGestureRecognizer) {
        
        searchGeoView.dismissKeyboard()

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
        viewModel.mapView(mapView, regionDidChangeAnimated: animated)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard view is LocationPinView else { return }
        
        //запомним, что выбрана аннотация isSelectedAnnotation = true
        self.isSelectedAnnotation = true
        
        //изменим MKAnnotationView
        view.isSelected = true
        
        if viewModel.mapViewAnnotationDidSelect(mapView: mapView, view: view) {
            self.newPlaceView.setInfo(point: viewModel.tapPointCoordinate,
                                      distance: viewModel.distance)
            self.newPlaceView.isHidden = false
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard view.annotation is LocationPin else { return }
        
       //очистим, что выбрана аннотация isSelectedAnnotation = true
        self.isSelectedAnnotation = false

        //изменим MKAnnotationView
        view.isSelected = false

        //очистим в модели выбранную точку
        viewModel.mapViewAnnotationDidDeselect(mapView: mapView, view: view)
    }
    
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


















extension MapPlanPointsVC: SearchGeoViewPotocol {
    
    func resizeButtonDidTap(_ view: SearchGeoView) {
        
        searchGeoView.resizeButtonIsUserInteractionEnabled = false
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            
            // Первая анимация: расширение searchView, меняем closeButton Constraints
            UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.25) {
                self.searchGeoView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(8)
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8)
                    make.height.equalTo(ConstSearchGeoViewSize.viewHeight)
                    make.width.equalTo(ConstSearchGeoViewSize.viewHeight
                                       + ConstSearchGeoViewSize.distanceBetween
                                       + ConstSearchGeoViewSize.buttonCloseWidth)
                }
                self.searchGeoView.setResizeViewFrame(status: 0)
                self.view.layoutIfNeeded()
            }
            
            // третья анимация: показываем closeButton, раздвигаем searchView и меняем textField Constraints
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.15) {
                self.searchGeoView.closeButtonAlpha = 1.0
                self.searchGeoView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(8)
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8)
                    make.height.equalTo(ConstSearchGeoViewSize.viewHeight)
                    make.width.equalTo(ConstSearchGeoViewSize.viewHeight*2
                                       + ConstSearchGeoViewSize.distanceBetween*2
                                       + ConstSearchGeoViewSize.buttonCloseWidth)
                }
                self.searchGeoView.setResizeViewFrame(status: 1)
                self.view.layoutIfNeeded()
            }
            
            // последняя анимация: показываем textField и расширяем до конца searchView
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.60) {
                self.searchGeoView.textFieldAlpha = 1.0
                self.searchGeoView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(8)
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8)
                    make.height.equalTo(ConstSearchGeoViewSize.viewHeight)
                    make.width.equalTo(self.view.frame.width - 8*2)
                }
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
    func closeButtonDidTap(_ view: SearchGeoView) {
        
        searchGeoView.resizeButtonIsUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.25) {
            self.searchGeoView.setResizeViewFrame(status: 2)
            self.searchGeoView.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(8)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8)
                make.height.equalTo(ConstSearchGeoViewSize.viewHeight)
                make.width.equalTo(ConstSearchGeoViewSize.viewHeight)
            }
            self.view.layoutIfNeeded()
            self.searchGeoView.closeButtonAlpha = 0.0
            self.searchGeoView.textFieldAlpha = 0.0
        }
    }
    
    func searchGeoViewShouldReturn(_ view: SearchGeoView) -> Bool {
        //всегда возвращаем true
        guard
            let coordinate2D = viewModel.mapViewSearchPointByText(
                mapView: mapView,
                searchText: searchGeoView.text
            )
        else { return true }
        
        let regionInMeters: CLLocationDistance = 500

        let coordinateRegion = MKCoordinateRegion(center: coordinate2D,
                                                  latitudinalMeters: regionInMeters,
                                                  longitudinalMeters: regionInMeters)
        let region = mapView.regionThatFits(coordinateRegion)

    // Используем UIView.animate для плавного перехода
        UIView.animate(withDuration: 2.5) {
            self.mapView.setRegion(region, animated: true)
        }

        self.newPlaceView.setInfo(point: viewModel.tapPointCoordinate,
                                  distance: viewModel.distance)
        self.newPlaceView.isHidden = false

        return true
    }
 }



















extension MapPlanPointsVC: NewPlaceDescriptionViewPotocol {
    func removeLastPointAnnotation() {
//        let vc = MyVC()
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .automatic
//        
//        self.present(vc, animated: true)
        
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

