//
//  UIAlertAction+Color.swift
//  WoodWander
//
//  Created by k.zubar on 28.08.24.
//

import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
