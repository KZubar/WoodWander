//
//  MKMapViewService.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import MapKit

final class MKMapViewService {
    
    /*
     Может обрабатывать координаты, разделенные пробелом, а не только запятой.
     
     1. Разделяем входную строку на компоненты по запятой и пробелу.
     2. Проверяем, что есть две компоненты, и преобразуем их в десятичные градусы.
     3. Если это не удается, мы пытаемся преобразовать координаты из форматов DDM или DMS с помощью вспомогательной функции convertDDMOrDMS.
     */
    public func convertToCoordinate2D(from input: String) -> CLLocationCoordinate2D? {
        // Удаляем лишние символы и разделяем строку на компоненты
        let cleanedInput = input.trimmingCharacters(in: CharacterSet(charactersIn: " ()\""))
        let components = cleanedInput.split { ", ".contains($0) }
        
        // Проверяем, что у нас есть две компоненты
        guard components.count == 2 else {
            return nil
        }
        
        // Определяем формат координат
        if let latitude = Double(components[0].trimmingCharacters(in: .whitespaces)),
           let longitude = Double(components[1].trimmingCharacters(in: .whitespaces)) {
            // Формат DD (десятичные градусы)
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else if let latitude = convertDDMOrDMS(toDecimal: components[0].trimmingCharacters(in: .whitespaces)),
                  let longitude = convertDDMOrDMS(toDecimal: components[1].trimmingCharacters(in: .whitespaces)) {
            // Формат DDM или DMS
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
    
    private func convertDDMOrDMS(toDecimal coordinate: String) -> Double? {
        // Разделяем координату на компоненты по пробелам и символам
        let parts = coordinate.split { "°'\" ".contains($0) }.map { String($0) }
        
        guard parts.count >= 2 else {
            return nil
        }
        
        // Преобразуем компоненты в градусы, минуты и секунды
        let degrees = Double(parts[0]) ?? 0
        let minutes = Double(parts[1]) ?? 0
        let seconds = parts.count > 2 ? Double(parts[2]) ?? 0 : 0
        
        // Преобразуем в десятичные градусы
        return degrees + (minutes / 60) + (seconds / 3600)
    }
    
    
    public func getZoomScale(mapView: MKMapView) -> Double {
        return mapView.visibleMapRect.size.width / Double(mapView.bounds.size.width)
    }

    public func getRegionInMeters(region: MKCoordinateRegion) -> (x: Double, y: Double) {
        let c = region.center
        let s = region.span
        let y = s.latitudeDelta / 2
        let x = s.longitudeDelta / 2

        let topLoc = CLLocation(latitude: c.latitude - y, longitude: c.longitude)
        let bottomLoc = CLLocation(latitude: c.latitude + y, longitude: c.longitude)
        
        let leftLoc = CLLocation(latitude: c.latitude, longitude: c.longitude - x)
        let rightLoc = CLLocation(latitude: c.latitude, longitude: c.longitude + x)

        let regionInMetersX = leftLoc.distance(from: rightLoc)
        let regionInMetersY = bottomLoc.distance(from: topLoc)

        return (x: regionInMetersX, y: regionInMetersY)
    }
    
    //// Получаем текущий регион карты
    public func getCurrentRegionInMeters(mapView: MKMapView) -> CLLocationDistance {
        /*
         Чтобы получить значение текущего региона карты в метрах, используем
         координаты текущего региона и вычислим расстояние между крайними
         точками региона.
         1. Получаем текущий регион карты.
         2. Вычисляем координаты северо-западного и юго-восточного углов региона.
         3. Используем CLLocation для вычисления расстояния между этими точками.
         4. Получаем расстояние в метрах.
        */
        
        // Получаем текущий регион карты
        let currentRegion = mapView.region
        let currentSpan = currentRegion.span
        let currentCenter = currentRegion.center

        // Вычисляем широту и долготу крайних точек региона
        let northWestCorner = CLLocationCoordinate2D(
            latitude: currentCenter.latitude + currentSpan.latitudeDelta / 2,
            longitude: currentCenter.longitude - currentSpan.longitudeDelta / 2
        )
        let southEastCorner = CLLocationCoordinate2D(
            latitude: currentCenter.latitude - currentSpan.latitudeDelta / 2,
            longitude: currentCenter.longitude + currentSpan.longitudeDelta / 2
        )
        
        // Вычисляем расстояние между крайними точками региона
        let northWestLocation = CLLocation(
            latitude: northWestCorner.latitude,
            longitude: northWestCorner.longitude
        )
        let southEastLocation = CLLocation(
            latitude: southEastCorner.latitude,
             longitude: southEastCorner.longitude
        )
        
        //Расстояние в метрах
        let distanceInMeters = northWestLocation.distance(from: southEastLocation)
        
        return distanceInMeters
    }
    
    public func getRadiusImage(region: MKCoordinateRegion) -> CLLocationDistance {
        let centerLoc = CLLocation(latitude: region.center.latitude,
                                   longitude: region.center.longitude)
        let topLoc = CLLocation(latitude: region.center.latitude - region.span.latitudeDelta / 2,
                                longitude: region.center.longitude)
        let radius = centerLoc.distance(from: topLoc)
        
        return radius
    }
    
    public func route(
        from firstCoordinate: CLLocationCoordinate2D,
        to secondCoordinate: CLLocationCoordinate2D) { }

    public func distanceByFormulaTo(
        point locationCoordinate: CLLocationCoordinate2D,
        user userCoordinate: CLLocationCoordinate2D
    ) -> Double {
        
        let lat_a = self.degreesToRadians(degrees: locationCoordinate.latitude)
        let lat_b = self.degreesToRadians(degrees: userCoordinate.latitude)
        let delta_long = self.degreesToRadians(degrees: locationCoordinate.longitude - userCoordinate.longitude)
        let cos_x = sin(lat_a) * sin(lat_b) + cos(lat_a) * cos(lat_b) * cos(delta_long)
        
        return acos(cos_x) * 6371009
    }
    
    public func distanceByLocatoinTo(
        point locationCoordinate: CLLocationCoordinate2D,
        user userCoordinate: CLLocationCoordinate2D
    ) -> CLLocationDistance {
        let pointLoc = CLLocation(latitude: locationCoordinate.latitude,
                                   longitude: locationCoordinate.longitude)
        let userLoc = CLLocation(latitude: userCoordinate.latitude,
                                longitude: userCoordinate.longitude)
        let distance = userLoc.distance(from: pointLoc)
        
        return distance
    }

    private func degreesToRadians(
        degrees: Double
    ) -> Double {
        return degrees * .pi / 180.0
    }

    //Передаем: координаты экрана и размер прямоугольника
    //Возвращаем: область на карте (находится ниже точки)
    //Для проверки наличия Annotation в указанной области
    public func getMapRectByPoint(
        mapView: MKMapView,
        point: CGPoint,
        sizeAnnotation: CGSize,
        addToSize: Double
    ) -> MKMapRect {
        
        let mapBounds = mapView.bounds
        
        var x: Double
        var y: Double

        var ww: Double = sizeAnnotation.width
        var hh: Double = sizeAnnotation.height

        // Верхний левый угол
            x = point.x - (ww / 2) - addToSize
            x = max(x, mapBounds.minX)
        
            y = point.y - (hh / 2) - addToSize
            y = max(y, mapBounds.minY)

            let point1: CGPoint = .init(x: x, y: y)
        
        // нижний правый угол
            x = point.x + (ww / 2) + addToSize
            x = min(x, mapBounds.maxX)
        
            y = point.y + (hh / 2) + addToSize
            y = min(y, mapBounds.maxY)

            let point2: CGPoint = .init(x: x, y: y)
        
        //------------------------------------------------------------
        //  Получим (latitude, longitude) этих точек на карте
        //------------------------------------------------------------
        
        //Точка в координатах Map (latitude, longitude)
        let tapPoint1: CLLocationCoordinate2D = mapView.convert(
            point1,
            toCoordinateFrom: mapView
        )
        let tapPoint2: CLLocationCoordinate2D = mapView.convert(
            point2,
            toCoordinateFrom: mapView
        )
        
        
//        //------------------------------------------------------------
//        ///
//        ///
//        /// - рисует линии для отладки
//        ///
//        ///
//
//        //массив точке для рисования
//        //var lineCoordinates: [CLLocationCoordinate2D] = []
//
//        //точки tapPoint1 (левый верхний угол) и tapPoint2 (нижний правый) уже описаны выше,
//        //  опишем еще две
//
//        // Верхний правый угол
//            x = point.x + (ww / 2) + addToSize
//            x = min(x, mapBounds.maxX)
//
//            y = point.y - (hh / 2) - addToSize
//            y = max(y, mapBounds.minY)
//
//            let point3: CGPoint = .init(x: x, y: y)
//
//        // нижний левый угол
//            x = point.x - (ww / 2) - addToSize
//            x = max(x, mapBounds.minX)
//
//            y = point.y + (hh / 2) + addToSize
//            y = min(y, mapBounds.maxY)
//
//            let point4: CGPoint = .init(x: x, y: y)
//
//        //Точка в координатах Map (latitude, longitude)
//            let tapPoint3: CLLocationCoordinate2D = mapView.convert(
//                point3,
//                toCoordinateFrom: mapView
//            )
//            let tapPoint4: CLLocationCoordinate2D = mapView.convert(
//                point4,
//                toCoordinateFrom: mapView
//            )
//
//        var lineCoordinates: [CLLocationCoordinate2D] = [tapPoint1, tapPoint3, tapPoint2, tapPoint4, tapPoint1]
//
//        //создадим полигон для вывода на карту
//        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
//        mapView.addOverlay(polyline)
//        ///
//        ///
//        ///
//        ///
//        //------------------------------------------------------------

        
        
        
        //------------------------------------------------------------
        //  Получим MKMapPoint(x, y) этих точек на карте
        //------------------------------------------------------------
        
        //Точка в координатах Map (x,y)
        let mapPoint1: MKMapPoint = .init(tapPoint1)
        let mapPoint2: MKMapPoint = .init(tapPoint2)

        //------------------------------------------------------------
        //  Получим width,height между этими точками на карте
        //------------------------------------------------------------
        
        //повторное использование переменных для других целей
        ww = 0.0
        hh = 0.0

        if mapPoint2.x > mapPoint1.x { ww = mapPoint2.x - mapPoint1.x } else { ww = mapPoint2.x / 2 }
        if mapPoint2.y > mapPoint1.y { hh = mapPoint2.y - mapPoint1.y } else { hh = mapPoint2.y / 2 }
        
        //------------------------------------------------------------
        //  Получим квадрат MKMapRect в координатах (X,Y, Size) карты
        //  В рамках квадрата будем искать Аннотации
        //------------------------------------------------------------
        
        let rect: MKMapRect = .init(
            origin: mapPoint1,
            size: .init(
                width: ww,
                height: hh
            )
        )

        return rect
    }

    
    public func getParamForRegion(mapView: MKMapView) -> LocationPinParameters {
        return (mapView.region.span.latitudeDelta < 1.0) ? LocationPinParameters.big : LocationPinParameters.small
    }
}
