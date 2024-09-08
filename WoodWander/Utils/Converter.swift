//
//  Converter.swift
//  WoodWander
//
//  Created by k.zubar on 2.07.24.
//

import Foundation
import UIKit

public struct Converter {
    
    public static func getDistanceMeterToKm(
        distance: Double,
        isSufix: Bool = true
    ) -> String {
     
        let distanceInt: Int = Int(distance) 

        if (distanceInt < 1000) { return "\(distanceInt) m." }

        let kilometors: Int = (distanceInt / 1000) // километры без остатка метров
        let a: Int = kilometors * 1000 // метры без учета остатка метров
        let b: Int = distanceInt - a // Остаток метров
        let c: Int = (b / 100) // Остаток метров в сотнях метрах

        if distance <= 10000 {
            return "\(separatedNumber(distance)) m."
        } else {
            return "\(separatedNumber(kilometors)),\(c) km."
        }

     }

    public static func separatedNumber(_ number: Any) -> String {
        guard
            let itIsANumber = number as? NSNumber
        else { return "Not a number" }
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        
        return formatter.string(from: itIsANumber) ?? "\(number)"
    }

}
