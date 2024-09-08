//
//  CategoriesPointMenuAction.swift
//  WoodWander
//
//  Created by k.zubar on 30.08.24.
//

import Foundation

protocol CategoriesPointMenuActionProtocol {
    var title: String { get}
}

public enum CategoriesPointMenuAction: CategoriesPointMenuActionProtocol {
    case disabled
    case edit
    case share
    case delete
    
    var title: String {
        switch self {
        case .disabled: return "Не показывать на карте"
        case .edit: return "Редактировать список"
        case .share: return "Поделиться списком"
        case .delete: return "Удалить список"
        }
    }
}
