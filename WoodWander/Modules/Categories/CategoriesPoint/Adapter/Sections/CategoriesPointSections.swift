//
//  CategoriesPointSections.swift
//  WoodWander
//
//  Created by k.zubar on 22.08.24.
//

import UIKit
import Storage

enum CategoriesPointSections {
    
    case predefined([CategoriesPointDTO])
    
    case custom([CategoriesPointDTO])
    
    var numberOfRows: Int {
        switch self {
        case .predefined(let rows): return rows.count
        case .custom(let rows): return rows.count
        }
    }
    
    var headerText: String {
        switch self {
        case .predefined: return "По умолчанию"
        case .custom: return "Пользовательские"
        }
    }
    
    
}
