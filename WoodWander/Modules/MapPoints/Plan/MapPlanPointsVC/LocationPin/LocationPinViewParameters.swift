//
//  LocationPinParameters.swift
//  WoodWander
//
//  Created by k.zubar on 5.08.24.
//

import Foundation
import UIKit

enum LocationPinParameters: CaseIterable {
    case small
    case big
    
    var rectWidth: Double { 20.0 }
    var rectHeight: Double { 20.0 }
    var circRadius: Double { 10.0 }
    var addToSizeRenderer: Double { 5.0 }
    
    var edgeOffset: Double {
        switch self {
        case .small:        return 1.50
        case .big:          return 2.00
        }
    }
    
    var koef: Double {
        switch self {
        case .small:        return 0.50
        case .big:          return 1.00
        }
    }
    
    var isHiddenImg: Bool {
        switch self {
        case .big:          return false
        default:            return true
        }
    }
    
//    var color: UIColor {
//        switch self {
//        case .small:        return UIColor.gradient1
//        case .big:          return UIColor.gradient2
//        }
//    }

    var sizeRenderer: CGSize {
        CGSize(width: rectWidth*koef, height: rectHeight*koef)
    }
    var sizeRendererIn: CGSize {
        CGSize(width: rectWidth*koef-edgeOffset*2, height: rectHeight*koef-edgeOffset*2)
    }
}
