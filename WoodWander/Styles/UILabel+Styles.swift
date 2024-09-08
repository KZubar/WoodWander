//
//  UILabel+Styles.swift
//  WoodWander
//
//  Created by k.zubar on 29.07.24.
//

import UIKit

extension UILabel {
    
    static func labelTitle25(_ title: String?) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = .appBoldFont.withSize(25.0)
        label.textColor = .mainFont
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }

    static func labelTitle17(_ title: String?) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .left
        label.font = .appBoldFont.withSize(17.0)
        label.textColor = .mainFont
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }

    static func welcomTitle(_ title: String?) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .appBoldFont.withSize(18.0)
        label.textColor = .mainFont
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }

}
