//
//  MenuPopOverVC.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import SnapKit

protocol MenuActionItem {
    var title: String { get}
    var icon: UIImage? { get }
}

protocol MenuPopOverDelegate: AnyObject {
    func didSelect(action: MenuPopOverVC.Action)
}

final class MenuPopOverVC: UIViewController {
    
    private enum L10n {
        static let delete: String = "global_delete".localizaed
        static let calendar: String = "global_calendar".localizaed
    
        static let edit: String = "global_edit".localizaed
        static let location: String = "global_location".localizaed
        static let timer: String = "global_timer".localizaed
    }

    enum Action: MenuActionItem {
        case edit
        case delete
        case calendar
        case timer
        case location
        
        var title: String {
            switch self {
            case .edit: return L10n.edit
            case .delete: return L10n.delete
            case .calendar: return L10n.calendar
            case .timer: return L10n.timer
            case .location: return L10n.location
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .edit: return .MenuAction.iconMenuEdit
            case .delete: return .MenuAction.iconMenuDelete
            case .calendar: return .MenuAction.iconMenuCalendar
            case .timer: return .MenuAction.iconMenuTimer
            case .location: return .MenuAction.iconMenuLocation
            }
        }

    }

}
