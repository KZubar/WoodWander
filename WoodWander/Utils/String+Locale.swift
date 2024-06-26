//
//  String+Locale.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import Foundation

extension String {
    var localizaed: String {
        return NSLocalizedString(self, comment: "")
    }
}
