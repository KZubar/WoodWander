//
//  GeoJSON.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

//import Foundation
//
//final class GeoJSON {
//    
//    typealias geo = [Double]
//
//    static func loadGeoBLR0() -> [geo] {
// 
//        guard
//            let path = Bundle.main.path(forResource: "BLR0", ofType: "json")
//        else {
//            print("[GeoJSON]: Bundle.main.path error to BLR0.json")
//            return []
//        }
//        
//        let url = URL(fileURLWithPath: path)
//        
//        guard
//            let data = try? Data(contentsOf: url)
//        else {
//            print("[GeoJSON]: Data error to \(path)")
//            return []
//        }
//
//        guard
//            let models = try? JSONDecoder().decode(BLR0Model.self, from: data)
//        else {
//            print("[GeoJSON]: Decode error to \(BLR0Model.self)")
//            return []
//        }
//
//        let coordinates = models
//            .features[0]
//            .geometry
//            .coordinates[0][0]
//            .compactMap { $0 }
//        
//        return coordinates
//    }
//
//}
