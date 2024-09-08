////
////  MapPlanPointsVC.swift
////  WoodWander
////
////  Created by k.zubar on 27.06.24.
////
//
//import UIKit
//import MapKit
//import SnapKit
//import CoreLocation
//
//final class MapPlanPointsVC: UIViewController {
//    
//    private enum L10n {
//        static let global_mapPalanPoints: String = "Планируемые места"
//    }
//
//    private enum ConstButton {
//        static let myGpsSize: Double = 45.0
//        static let cancelHeight: Double = 45.0
//    }
//
//    private lazy var contentView: UIView = .setContentView()
//    private var isSelectedAnnotation: Bool = false
//    
//    private lazy var newPlaceView: NewPlaceDescriptionView = {
//        let view = NewPlaceDescriptionView()
//        view.delegat = self
//        view.isHidden = true
//        return view
//    }()
//
//    private lazy var mapView: MKMapView = {
//        let mapView = MKMapView()
//        mapView.delegate = self
//        mapView.showsUserLocation = true
//        return mapView
//    }()
//    
//    private var viewModel: MapPlanPointsViewModelProtocol
//
//    private lazy var userRegionButton: UIButton = {
//        let bttn = UIButton()
//        bttn.backgroundColor = .yellow //FIXME: .appYellow
//        bttn.setImage(.Temp.icon_gpsArrowBlack, for: .normal)
//        bttn.setBorder(width: 0.25, color: .black) //FIXME: .appBlack
//        bttn.setShadow()
//        bttn.cornerRadius = ConstButton.myGpsSize / 2
//        bttn.addTarget(self, action: #selector(userRegionButtonDidTap), for: .touchUpInside)
//        return bttn
//    }()
//    
//    init(viewModel: MapPlanPointsViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("\(Self.self) was called by coder")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//        bind()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        viewModel.registerLocationAnnotation(mapView: mapView)
//        
//        // Single Tap
//        let singleTapMap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(mapViewHandleSingleTap(recognizer:))
//        )
//        singleTapMap.numberOfTapsRequired = 1
//        self.mapView.addGestureRecognizer(singleTapMap)
//
//        // Double Tap
//        let doubleTapMap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(mapViewHandleDoubleTap(recognizer:))
//        )
//        doubleTapMap.numberOfTapsRequired = 2
//        self.mapView.addGestureRecognizer(doubleTapMap)
//        
//        //Создает зависимость между средством распознавания жестов
//        //  и другим средством распознавания жестов при создании объектов
//        singleTapMap.require(toFail: doubleTapMap)
//        
//        //задерживает ли распознаватель жестов отправку касаний
//        //  на начальной фазе в свой режим просмотра.
//        singleTapMap.delaysTouchesBegan = true
//        doubleTapMap.delaysTouchesBegan = true
//    }
//    
//    private func bind() {
//        //setupTabBarItem()
//
//        //mapView.mapType = .standard
//        mapView.mapType = .hybrid
//        
//        viewModel.viewDidLoad(mapView: mapView)
//        
//        
////        //FIXME: - delete
////        let dataSourse = EventDataSourse()
////        mapView.addOverlays(dataSourse.overlays)
////        mapView.addAnnotations(dataSourse.annotation)
//
//    }
//
//    private func setupUI() {
//        self.view.backgroundColor = .black //FIXME: .appBlack
//        
//        self.view.addSubview(contentView)
//        self.view.addSubview(userRegionButton) //FIXME: где картинка делась?
// 
//        self.contentView.addSubview(mapView)
//        self.contentView.addSubview(newPlaceView)
//
//    }
//    
//    private func setupConstraints() {
//        contentView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
//        mapView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.verticalEdges.equalToSuperview()
//        }
//        userRegionButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().inset(20.0)
//            make.bottom.equalToSuperview().inset(-ConstButton.myGpsSize)
//            make.size.equalTo(ConstButton.myGpsSize)
//        }
//        newPlaceView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(8)
//            make.bottom.equalTo(-8)
//            //make.bottom.equalToSuperview().inset(-16)
//            //make.height.equalTo(100)
//        }
//    }
//
//    @objc private func userRegionButtonDidTap(_ sender: UIButton) {
//        viewModel.setUserRegion(mapView: mapView)
//    }
//    
//    
//    
//    
//    @objc private func mapViewHandleSingleTap(recognizer: UITapGestureRecognizer) {
//        
//        if self.isSelectedAnnotation { return }
//
//        if recognizer.state == .ended {
//            
//            //FIXME: - add const
//            let sizeAnnotation: CGSize = CGSize(width: 45.0, height: 45.0)
//            let addToSize: Double = 5.0
//
//            //точка в координатах экрана
//            let point = recognizer.location(in: mapView)
//
//            //попали в Annotation или нет
//            if viewModel.isAnnotationInArea(
//                mapView: mapView,
//                point: point,
//                sizeAnnotation: sizeAnnotation,
//                addToSize: addToSize,
//                mapBounds: mapView.bounds
//            ) {
//                return
//            }
//            
//            guard
//                let tapPoint = viewModel.initTapPoint(
//                    mapView: mapView,
//                    point: point
//                )
//            else { return }
//            
//            let distance = viewModel.distanceTo(locationCoordinate: tapPoint)
//            
//            self.newPlaceView.setInfo(point: tapPoint, distance: distance)
//            if self.newPlaceView.isHidden {
//                mapView.setCenter(tapPoint, animated: true)
//            }
//            self.newPlaceView.isHidden = false
//
//            
//        }
//    }
//    
//    @objc private func mapViewHandleDoubleTap(recognizer: UITapGestureRecognizer) {
//        
//
//    }
//
//}
//
//extension MapPlanPointsVC: MKMapViewDelegate {
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        self.isSelectedAnnotation = true
//        view.isSelected = true
//    }
//    
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        self.isSelectedAnnotation = false
//        view.isSelected = false
//    }
//    
//    func mapView(
//        _ mapView: MKMapView,
//        annotationView view: MKAnnotationView,
//        didChange newState: MKAnnotationView.DragState,
//        fromOldState oldState: MKAnnotationView.DragState
//    ) {}
//    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let multiPolygon = overlay as? MKMultiPolygon {
//            let renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
//            renderer.fillColor = UIColor.blue.withAlphaComponent(0.15)
//            renderer.strokeColor = .yellow
//            renderer.lineWidth = 1.0
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//    
//}
//
//
//extension MapPlanPointsVC: NewPlaceDescriptionViewPotocol {
//    func removeLastPointAnnotation() {
//        self.newPlaceView.isHidden = true
//        viewModel.removeLastPointAnnotation(mapView: mapView)
//    }
//    func openCreatePlanPontVC() {
//        self.newPlaceView.isHidden = true
//        viewModel.removeLastPointAnnotation(mapView: mapView)
//    }
//}
