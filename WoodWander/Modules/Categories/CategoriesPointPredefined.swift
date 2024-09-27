//
//  CategoriesPointPredefined.swift
//  WoodWander
//
//  Created by k.zubar on 30.08.24.
//

import Foundation

public enum CategoriesPointPredefined {
    
    case favorites
    
    var uuid: String {
        switch self {
        case .favorites: return "00000000-0000-0000-0000-000000000001"
        }
    }

    var name: String {
        switch self {
        case .favorites: return "Избранное"
        }
    }

    var icon: String {
        switch self {
        case .favorites: return "❤️"

        }
    }
}
