//
//  MainTabBarVM.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

protocol MainTabBarCoordinatorProtocol: AnyObject { }

final class MainTabBarVM: MainTabBarViewModelProtocol {
    
    private weak var coordinator: MainTabBarCoordinatorProtocol?
    
    init(coordinator: MainTabBarCoordinatorProtocol) {
        self.coordinator = coordinator
    }
        
}
