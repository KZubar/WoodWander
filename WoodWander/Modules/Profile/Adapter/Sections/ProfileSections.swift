//
//  ProfileSections.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

enum ProfileSections {
    
    case account(String)
    case settings([ProfileSettingsRows])
    
    var numberOfRows: Int {
        switch self {
        case .settings(let rows): return rows.count
        default: return 1
        }
    }
    
    var headerText: String {
        switch self {
        case .account: return "Учетная запись"
        case .settings: return "Настройки"
        }
    }
}


enum ProfileSettingsRows: CaseIterable {
    
    case mapAllPoints
    case blrLoad
    case completedNotification
    case notifications
    case export
    case logout
    
    var icon: UIImage {
        switch self {
            //FIXME: -
        case .mapAllPoints: return .Temp.addAction
        case .blrLoad: return .Temp.addAction
        case .completedNotification: return .Temp.addAction
        case .notifications: return .Temp.addAction
        case .export: return .Temp.addAction
        case .logout: return .Temp.addAction
        }
    }
    
    var title: String {
        switch self {
        case .mapAllPoints: return "Активные локации на карте"
        case .blrLoad: return "Обновить границы областей и регионов"
        case .completedNotification: return "Завершенные уведомления"
        case .notifications: return "Оповещения"
        case .export: return "Экспорт"
        case .logout: return "Выйти"
        }
    }
    
    var infoText: String? {
        switch self {
        case .mapAllPoints: return "Карта"
        case .blrLoad: return "Загрузить"
        case .completedNotification: return "Открыть"
        case .export: return "Выполнить"
        default: return nil
        }
    }
}
