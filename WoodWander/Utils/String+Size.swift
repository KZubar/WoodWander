//
//  String+Size.swift
//  WoodWander
//
//  Created by k.zubar on 3.10.24.
//

import Foundation
import UIKit

extension String {
    func minimumWidthToDisplay(font: UIFont, height: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = self
        label.font = font
        return label
            .sizeThatFits(.init(width: .infinity, height: height))
            .width
    }
}
