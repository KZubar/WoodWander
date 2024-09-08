//
//  UIButton+Styles.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit

extension UIButton {

    static func yellowRoundedButton(_ title: String?) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .appYellow
        button.cornerRadius = 5.0
        button.setTitle(title, for: .normal)
        button.setTitleColor(.mainFont, for: .normal) //цвет обычной кнопки
        button.setTitleColor(.mainFont.withAlphaComponent(0.75), for: .highlighted) //цвет нажатия
        
        button.titleLabel?.font = .appBoldFont.withSize(17.0)
        
        return button
    }
    
    static func cancelYellowButton() -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .appBlack
        button.cornerRadius = 5.0
        button.setBorder(width: 1.0, color: .appYellow)
        
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(.appYellow, for: .normal) //цвет обычной кнопки
        button.setTitleColor(.appYellow.withAlphaComponent(0.75),
                             for: .highlighted) //цвет нажатия
        
        button.titleLabel?.font = .appBoldFont.withSize(17.0)
        
        return button
    }
    
    static func bigButton(title: String,
                          image: UIImage? = nil,
                          titleColor: UIColor? = nil,
                          backgroundColor: UIColor? = nil) -> UIButton {

        let button = UIButton()
        
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .appBlue

        if let color = backgroundColor {
            button.backgroundColor = color
        } else {
            button.backgroundColor = .appBlueLight
        }
        button.cornerRadius = 10.0
        button.setBorder(width: 1.5, color: .appBlue)
        
        button.setTitle(title, for: .normal)
        
        if let color = titleColor {
            button.setTitleColor(color, for: .normal) //цвет обычной кнопки
            button.setTitleColor(color.withAlphaComponent(0.75), for: .highlighted) //цвет нажатия
        } else {
            button.setTitleColor(.appBlue, for: .normal) //цвет обычной кнопки
            button.setTitleColor(.appBlue.withAlphaComponent(0.75), for: .highlighted) //цвет нажатия
        }

        
        button.titleLabel?.font = .appBoldFont.withSize(16.0)
        
        return button
    }

    static func underlineYellowButton(_ title: String) -> UIButton {
        return underlineButton(title,
                               color: .appYellow,
                               font: .appBoldFont.withSize(17.0))
    }
    
    static func underlineGrayButton(_ title: String) -> UIButton {
        return underlineButton(title,
                               color: .appGreen,
                               font: .appBoldFont.withSize(15.0))
    }

    static func underlineButton(_ title: String,
                                color: UIColor,
                                font: UIFont
    ) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .clear
        
        let normalAttr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: color
        ]
        button.setAttributedTitle(.init(string: title, attributes: normalAttr), for: .normal)

        let highlightAttr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color.withAlphaComponent(0.75),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: color.withAlphaComponent(0.75)
        ]
        button.setAttributedTitle(.init(string: title, attributes: highlightAttr), for: .highlighted)

        return button
    }
    
}
