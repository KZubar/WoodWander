//
//  UIView+Layer.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setShadow(corRadius: CGFloat = 5.0,
                   shadRadius: CGFloat = 5.0,
                   shadOpacity: Float = 0.2) {
        self.clipsToBounds = false
        self.layer.cornerRadius = corRadius
        self.layer.shadowColor = UIColor.mainFont.cgColor
        self.layer.shadowOffset = CGSize(width: shadRadius,
                                         height: shadRadius)
        self.layer.shadowRadius = shadRadius
        self.layer.shadowOpacity = shadOpacity
    }
    
    func addShadow(corRadius: CGFloat,
                   shadRadius: CGFloat,
                   shadOpacity: Float) {
        self.subviews.forEach { view in
            view.setShadow(corRadius: corRadius,
                           shadRadius: shadRadius,
                           shadOpacity: shadOpacity)
        }
    }
    
}
