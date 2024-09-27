//
//  MapPlanPointsViewModel+Protocol.swift
//  WoodWander
//
//  Created by k.zubar on 8.09.24.
//

import MapKit
import StorageBLR
import Storage

//Coordinator
protocol MapPlanPointsCoordinatorProtocol: AnyObject {
    func startCreatePlanPointModule(
        point: PlanPointDescription
    )
    func startCategoriesPointModule(
        point: PlanPointDescription
    )
    func startIconModule()
}

//MKMapViewService
protocol MapPlanPointsMKMapViewServiceUseCase {
    func getZoomScale(mapView: MKMapView) -> Double
    func getRadiusImage(region: MKCoordinateRegion) -> CLLocationDistance
    func getRegionInMeters(region: MKCoordinateRegion) -> (x: Double, y: Double)
    func getCurrentRegionInMeters(mapView: MKMapView) -> CLLocationDistance
    func getParamForRegion(mapView: MKMapView) -> LocationPinParameters
    func convertToCoordinate2D(from input: String) -> CLLocationCoordinate2D?
    
    func distanceByFormulaTo(
        point locationCoordinate: CLLocationCoordinate2D,
        user userCoordinate: CLLocationCoordinate2D
    ) -> Double
    
    func getMapRectByPoint(
        mapView: MKMapView,
        point: CGPoint,
        sizeAnnotation: CGSize,
        addToSize: Double
    ) -> MKMapRect
}

//PlanPointDataWorker
protocol MapPlanPointsPlanPointDataWorkerUseCase {
    
    typealias CompletionHandler = (Bool) -> Void

    func fetch(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]
    ) -> [any DTODescriptionPlanPoint]
    
    func fetchPPCategories(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]
    ) -> [any DTODescriptionPPCategories]
    
    func deleteByUser(dto: (any DTODescriptionPlanPoint),
                      completion: CompletionHandler?)
}

//LocationHelper
protocol MapPlanPointsLocationHelperUseCase {
    typealias AlertActionHandler = () -> Void
    
    var showMessageEnableGeoLocationHandler: AlertActionHandler? { get set }
    var showMessageEnableLocationHandler: AlertActionHandler? { get set }
    
    func checkAutorization(status: CLAuthorizationStatus)
    func getUserLocation() -> CLLocationCoordinate2D?
}


//    //Добавления тепловой карты, чтобы учитывать плотность:
//    private func addHeatmap(mapView: MKMapView, locPins: [LocationPin]) {
//
//        var densityMap: [CLLocationCoordinate2D: Double] = [:]
//
//        // Рассчитайте плотность для каждой точки
//        for location in locPins {
//            let latitude = location.coordinate.latitude.roundToNearestValue(1)
//            let longitude = location.coordinate.longitude.roundToNearestValue(1)
//
//            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//            if let density = densityMap[coordinate] {
//                densityMap[coordinate] = density + 1
//            } else {
//                densityMap[coordinate] = 1
//            }
//        }
//
//        // Добавьте круги с учетом плотности
//        for (location, density) in densityMap {
//            let circle = MKCircle(center: location, radius: 2000)
//            circle.title = "\(density)"
//            mapView.addOverlay(circle)
//        }
//    }
//
//    //Вычисление цвета на основе плотности:
//    func color(forDensity density: Double) -> UIColor {
//        let colors = [
//            UIColor.blue.withAlphaComponent(0.15),
//            UIColor.green.withAlphaComponent(0.15),
//            UIColor.yellow.withAlphaComponent(0.15),
//            UIColor.red.withAlphaComponent(0.15)
//        ]
//        let index = min(max(Int(density * Double(colors.count - 1)), 0), colors.count - 1)
//
//        var ind: Int = 0
//        if index < 3 {
//            ind = 0
//        } else if index >= 3 && index < 5 {
//            ind = 1
//        } else {
//            ind = 2
//        }
//
//
//        return colors[ind]
//    }
//




//Понял вас. Для создания тепловой карты с размытыми границами и плавными переходами между цветами, можно использовать градиентные наложения. Вот пример, как это можно реализовать:
//
//1.
//Создайте градиентный наложение:
//•  Вместо использования MKCircle, создайте собственный класс наложения, который будет рисовать градиент.
//2.
//Создайте класс для градиентного наложения:
//
//import MapKit
//
//class GradientOverlay: NSObject, MKOverlay {
//    var coordinate: CLLocationCoordinate2D
//    var boundingMapRect: MKMapRect
//
//    init(center: CLLocationCoordinate2D, radius: CLLocationDistance) {
//        self.coordinate = center
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: radius * 2, longitudinalMeters: radius * 2)
//        self.boundingMapRect = MKMapRect(region)
//    }
//}
//
//1.
//Создайте рендерер для градиентного наложения:
//
//class GradientOverlayRenderer: MKOverlayRenderer {
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//        guard let gradientOverlay = overlay as? GradientOverlay else { return }
//
//        let rect = self.rect(for: gradientOverlay.boundingMapRect)
//        let colors = [UIColor.red.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor] as CFArray
//        let locations: [CGFloat] = [0.0, 1.0]
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)!
//
//        context.saveGState()
//        context.addEllipse(in: rect)
//        context.clip()
//        context.drawRadialGradient(gradient, startCenter: CGPoint(x: rect.midX, y: rect.midY), startRadius: 0, endCenter: CGPoint(x: rect.midX, y: rect.midY), endRadius: rect.width / 2, options: .drawsAfterEndLocation)
//        context.restoreGState()
//    }
//}
//
//1.
//Добавьте градиентные наложения на карту:
//
//func addGradientHeatmap() {
//    for location in locations {
//        let overlay = GradientOverlay(center: location, radius: 1000)
//        mapView.addOverlay(overlay)
//    }
//}
//
//1.
//Настройте делегат для отображения градиентных наложений:
//
//extension ViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is GradientOverlay {
//            return GradientOverlayRenderer(overlay: overlay)
//        }
//        return MKOverlayRenderer()
//    }
//}
//
//1.
//Вызовите функцию добавления градиентной тепловой карты в viewDidLoad:
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    mapView.delegate = self
//    addGradientHeatmap()
//}
//
//Этот код создаст тепловую карту с размытыми границами и плавными переходами между цветами, что позволит вам получить более естественное отображение плотности точек, как на картах с прогнозом погоды.
//
//Если у вас возникнут дополнительные вопросы или потребуется помощь, дайте знать!
