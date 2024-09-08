//
//  ChooseCategoriesPointSections.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit
import Storage


enum ChooseCategoriesPointSections {
    
    case predefined, custom
    
    var headerText: String {
        switch self {
        case .predefined: return "По умолчанию"
        case .custom: return "Пользовательские"
        }
    }
    
}

//enum ChooseCategoriesPointSections {
//    
//    case predefined([CategoriesPointDTO])
//    
//    case custom([CategoriesPointDTO])
//    
//    var numberOfRows: Int {
//        switch self {
//        case .predefined(let rows): return rows.count
//        case .custom(let rows): return rows.count
//        }
//    }
//    
//    var headerText: String {
//        switch self {
//        case .predefined: return "По умолчанию"
//        case .custom: return "Пользовательские"
//        }
//    }
//    
//    
//}
