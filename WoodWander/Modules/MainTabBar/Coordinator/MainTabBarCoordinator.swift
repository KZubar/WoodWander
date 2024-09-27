//
//  MainTabBarCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import SwiftIcons

final class MainTabBarCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    
    private weak var delegat: (any AppCoordinatorDelegate)?
    
    init(container: Container, delegat: AppCoordinatorDelegate) {
        self.container = container
        self.delegat = delegat
    }
    
    override func start() -> TabBarController {
        let tabBar = TabBarController(modules: setupControllers())
        self.rootVC = tabBar
        return tabBar
    }

    private func makeMapPlanPointsModule() -> UIViewController {
        let coordinator = MapPlanPointsCoordinator(container: container)
        children.append(coordinator)
        let vc = coordinator.start()
        return vc
    }
 
    private func makeCategoriesPointModule() -> UIViewController {
        let coordinator = CategoriesPointCoordinator(container: container)
        children.append(coordinator)
        let vc = coordinator.start()
        return vc
    }

    private func makeProfileModule() -> UIViewController {
        let coordinator = ProfileCoordinator(container: container)
        children.append(coordinator)
        let vc = coordinator.start()
        return vc
    }
    

}

extension MainTabBarCoordinator {
    private func setupControllers() -> [TabBarModule] {
        
        guard let delegat = self.delegat else { return [] }
        
        let mapPlanPoints = makeMapPlanPointsModule()
        let categoriesPointModule = makeCategoriesPointModule()
        let profileModule = makeProfileModule()
 
        return [
            TabBarModule(
                 coordinator: mapPlanPoints,
                 button: TabBarButton(icon: UIImage.TabBar.addLocation, style: .standard, text: "Карта меток"),
                 delegate: delegat
             ),
            TabBarModule(
                coordinator: categoriesPointModule,
                button: TabBarButton(icon: UIImage.TabBar.clipboard, style: .standard, text: "Списки"),
                delegate: delegat
            ),
            TabBarModule(
                coordinator: .init(),
                button: TabBarButton(icon: nil, style: .central, text: nil),
                delegate: delegat
            ),
            TabBarModule(
                coordinator: .init(),
                button: TabBarButton(icon: UIImage.TabBar.mapPins, style: .standard, text: "Карта поездок"),
                delegate: delegat
            ),
            TabBarModule(
                coordinator: profileModule,
                button: TabBarButton(icon: UIImage.TabBar.userAlt3, style: .standard, text: "Профиль"),
                delegate: delegat
            ),
       ]
        
    }
}
