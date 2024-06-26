//
//  ProfileSections.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

fileprivate enum L10n {
    static let headerText_account: String = "global_account".localizaed
    static let headerText_settings: String = "global_settings".localizaed
    
    static let title_mapAllPoints: String = "global_mapAllPoints".localizaed
    static let title_completedNotification: String = "global_completedNotification".localizaed
    static let title_notifications: String = "global_notifications".localizaed
    static let title_export: String = "global_export".localizaed
    static let title_logout: String = "global_logout".localizaed
}


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
        case .account: return L10n.headerText_account
        case .settings: return L10n.headerText_settings
        }
    }
}


enum ProfileSettingsRows: CaseIterable {
    
    case mapAllPoints
    case completedNotification
    case notifications
    case export
    case logout
    
    var icon: UIImage {
        switch self {
            //FIXME: -
        case .mapAllPoints: return .Temp.addAction
        case .completedNotification: return .Temp.addAction
        case .notifications: return .Temp.addAction
        case .export: return .Temp.addAction
        case .logout: return .Temp.addAction
//        case .mapAllPoints: return .MenuMapAction.iconMenuHybrid
//        case .completedNotification: return .General.completedNotification
//        case .notifications: return .General.notifications
//        case .export: return .General.export
//        case .logout: return .General.logout
        }
    }
    
    var title: String {
        switch self {
        case .mapAllPoints: return L10n.title_mapAllPoints
        case .completedNotification: return L10n.title_completedNotification
        case .notifications: return L10n.title_notifications
        case .export: return L10n.title_export
        case .logout: return L10n.title_logout
        }
    }
    
    var infoText: String? {
        switch self {
        case .mapAllPoints: return "Map"
        case .completedNotification: return "Open"
        case .export: return "Now"
        default: return nil
        }
    }
}
