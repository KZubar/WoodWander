//
//  MainTabBarVM.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

protocol MainTabBarCoordinatorProtocol: AnyObject {
    //FIXME: - правильный вариант - вариант с делегатом
    //func showMenu(sender: UIView, delegat: MenuPopOverDelegate)
    func showMenu(sender: UIView)
    
    func openNewCalendarNotification()
    func openNewTimerNotification()
    func openNewLocationNotification()
}

final class MainTabBarVM: MainTabBarViewModelProtocol {
    
    private weak var coordinator: MainTabBarCoordinatorProtocol?
    
    init(coordinator: MainTabBarCoordinatorProtocol) {
        self.coordinator = coordinator
    }
        
    func addButtonDidTap(sender: UIView) {
        //FIXME: - правильный вариант - вариант с делегатом
        //coordinator?.showMenu(sender: sender, delegat: self)
        coordinator?.showMenu(sender: sender)
    }
}

extension MainTabBarVM: MenuPopOverDelegate {
    
    func didSelect(action: MenuPopOverVC.Action) {
        switch action {
        case .calendar: coordinator?.openNewCalendarNotification()
        case .location: coordinator?.openNewLocationNotification()
        case .timer: coordinator?.openNewTimerNotification()
        default: break
        }
    }
    
}
