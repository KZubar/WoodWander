//
//  CategoriesPointPredefined.swift
//  WoodWander
//
//  Created by k.zubar on 30.08.24.
//

import Foundation

public enum CategoriesPointPredefined {
    
    case favorites
    
    case marked

    var uuid: String {
        switch self {
        case .favorites: return "00000000-0000-0000-0000-000000000001"
        case .marked: return "00000000-0000-0000-0000-000000000002"
        }
    }

    var name: String {
        switch self {
        case .favorites: return "Избранное"
        case .marked: return "Отмеченное"
        }
    }

    var icon: String {
        switch self {
        case .favorites: return "❤️"
        case .marked: return "🩵"
        }
    }
}
