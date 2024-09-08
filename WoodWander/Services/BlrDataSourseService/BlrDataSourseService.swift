//
//  BlrDataSourseService.swift
//  WoodWander
//
//  Created by k.zubar on 7.07.24.
//

import MapKit
import StorageBLR

final class BlrDataSourseService {

    typealias CompletionHandler = (Bool) -> Void
    typealias CompletionHandlerDtos = ([BlrDTO]) -> Void

    var overlays = [MKOverlay]()
    var annotation = [MKAnnotation]()
    
    private var dtos = [BlrDTO]()
    
    public init() { }
    
    public func getDtos(name: String, completion: CompletionHandlerDtos? = nil) {
        if let jsonUrl = Bundle.main.url(forResource: name, withExtension: "json") {
            
            //обнуляем
            self.dtos.removeAll()
            self.overlays.removeAll()
            self.annotation.removeAll()
            
            do {
                let eventData = try Data(contentsOf: jsonUrl)
                let decoder = MKGeoJSONDecoder()
                let jsonObjects = try decoder.decode(eventData)
                parser(jsonObjects)
            } catch {
                print("[EventDataSourse] Error decoding GeoJSON: \(error).")
            }
            
            completion?(self.dtos)
        }
    }
    
    public func getDtos(name: String) -> [BlrDTO]? {
        //обнуляем
        self.dtos.removeAll()
        self.overlays.removeAll()
        self.annotation.removeAll()

        if let jsonUrl = Bundle.main.url(forResource: name, withExtension: "json") {
            do {
                let eventData = try Data(contentsOf: jsonUrl)
                let decoder = MKGeoJSONDecoder()
                let jsonObjects = try decoder.decode(eventData)
                parser(jsonObjects)
            } catch {
                print("[EventDataSourse] Error decoding GeoJSON: \(error).")
            }
        }
        return self.dtos
    }

    private func parser(_ jsonObjects: [MKGeoJSONObject]) {
        for object in jsonObjects {
            if let feature = object as? MKGeoJSONFeature {
                for geometry in feature.geometry {
                    
                    if let multiPoligon = geometry as? MKMultiPolygon {
                        configure(multiPoligon: multiPoligon, using: feature.properties)
                        overlays.append(multiPoligon)
                    } else if let point = geometry as? MKPointAnnotation {
                        configure(annotation: point, using: feature.properties)
                        annotation.append(point)
                    }
   
                }
            }
        }
    }
    
    private func configure(annotation: MKPointAnnotation, using properties: Data?) {
        guard let properties = properties else {
            return
        }
        
        let decoder = JSONDecoder()
        if let dictionary = try? decoder.decode([String: String].self, from: properties) {
            annotation.title = dictionary["name"]
        }
    }
    
    private func configure(multiPoligon: MKMultiPolygon, using properties: Data?) {
        guard let properties = properties else {
            return
        }
        
        var dto: BlrDTO? = nil
        
        let decoder = JSONDecoder()
        if let dictionary = try? decoder.decode([String: String].self, from: properties) {
            
            
            let poligon = multiPoligon.polygons[0]
            let pointCount = poligon.pointCount
            let coordinate = poligon.coordinate
            let points = poligon.points()
            
            var coordinates: [[Double]] = [[]]
            for i in 0..<pointCount {
                coordinates.append([points[i].x, points[i].y])
            }
            
            dto = BlrDTO(
                latitude:   coordinate.latitude,
                longitude:  coordinate.longitude,
                country:    dictionary["COUNTRY"],      //Belarus
                engType_1:  dictionary["ENGTYPE_1"],    //Region
                engType_2:  dictionary["ENGTYPE_2"],    //District
                gid_0:      dictionary["GID_0"],        //BLR
                gid_1:      dictionary["GID_1"],        //BLR.1_1
                gid_2:      dictionary["GID_2"],        //BLR.1.1_1
                hasc_1:     dictionary["HASC_1"],
                hasc_2:     dictionary["HASC_2"],       //"BY.BR.BA"
                name_0:     dictionary["NAME_0"],
                name_1:     dictionary["NAME_1"],       //Brest
                name_2:     dictionary["NAME_2"],       //Baranavichy
                nl_name_1:  dictionary["NL_NAME_1"],
                nl_name_2:  dictionary["NL_NAME_2"],    //"Баранавіцкіраён"
                type_0:     dictionary["TYPE_0"],       //Oblast
                type_1:     dictionary["TYPE_1"],       //Oblast
                type_2:     dictionary["TYPE_2"],       //Raion
                varname_1:  dictionary["VARNAME_1"],    //
                varname_2:  dictionary["VARNAME_2"],    //"Baranovichi"
                coordinates: coordinates)
            
            if let dto = dto {
                self.dtos.append(dto)
            }
        }
        
        if let dto = dto {
            multiPoligon.title = dto.title
            multiPoligon.subtitle = dto.subtitle
        }
    }
}
