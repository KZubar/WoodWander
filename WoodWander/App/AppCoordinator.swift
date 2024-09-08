//
//  AppCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import Storage

protocol AppCoordinatorDelegate: AnyObject {
    func openTab(_ tab: Int)
    func logout()
}

final class AppCoordinator: Coordinator {

    private var container: Container
    private var windowsManager: WindowManager
    private var tabBar: TabBarController?

    init(container: Container) {
        self.container = container
        self.windowsManager = container.resolve()
    }
    
    func startApp() {
        openMainApp()
    }

    private func openMainApp() {
        let coordinator = MainTabBarCoordinator(container: container,
                                                delegat: self)
        
        self.children.append(coordinator)

        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll { $0 == coordinator}
            self?.startApp()
        }

        self.tabBar = coordinator.start()
        
        let window = windowsManager.get(type: .main)
        window.rootViewController = tabBar
        windowsManager.show(type: .main)
        
        self.tabBar?.selectTab(index: 0)
        
    }

}


extension AppCoordinator: AppCoordinatorDelegate {
    func openTab(_ tab: Int) {
        self.tabBar?.selectTab(index: tab)
    }

    func logout() {
        self.startApp()
    }
}
