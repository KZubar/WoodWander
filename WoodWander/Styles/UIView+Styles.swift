//
//  UIView+Styles.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

extension UIView {
    
    static func setInfoView() -> UIView {
        let view = UIView()
        view.setShadow()
        view.backgroundColor = .white
        
        return view
    }
    
    static func setContentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray3 //FIXME: .appGray
        return view
    }


}
