//
//  UIButton+Actions.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit

extension UIButton {
    
    @discardableResult //означает, что результат не всегда нужен
    func withAction(
        _ target: Any?,
        _ selector: Selector,
        for event: UIControl.Event = .touchUpInside
    ) -> UIButton {
        self.addTarget(target, action: selector, for: event)
        return self
    }
    
}
