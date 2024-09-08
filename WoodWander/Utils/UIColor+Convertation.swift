//
//  UIColor+Convertation.swift
//  WoodWander
//
//  Created by k.zubar on 12.08.24.
//

import Foundation
import UIKit

extension UIColor {
    
    static func hexToRGB(hexStr: String) -> UIColor {

        let getHEX = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int = UInt64()
        
        Scanner(string: getHEX).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch getHEX.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
    static func rgbToHex(color: UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let argb:Int = (Int)(a*255)<<24 | (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%08x", argb)
    }
    
    public func rgbToHex() -> String { UIColor.rgbToHex(color: self) }

}
