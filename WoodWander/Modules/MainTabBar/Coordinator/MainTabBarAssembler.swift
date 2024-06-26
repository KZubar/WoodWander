//
//  MainTabBarAssembler.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

final class MainTabBarAssembler{
    
    private init() {}
    
    static func make(coordinator: MainTabBarCoordinatorProtocol) -> UITabBarController {
        let vm = MainTabBarVM(coordinator: coordinator)
        return MainTabBarVC(viewModel: vm)
    }
    
}
