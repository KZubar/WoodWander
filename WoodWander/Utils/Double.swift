//
//  Double.swift
//  WoodWander
//
//  Created by k.zubar on 2.07.24.
//

import Foundation

extension Double {
    
    func roundToNearestValue(_ value: Double) -> Double {
        
        var a = self
        
        if value == 0 { a.round() }
        
        let b: Double = pow(10, value)
        
        var tmp = a * b
        
        tmp.round()
        
        return tmp / b
        
    }

}
