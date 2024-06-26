//
//  MainTabBarCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let tabBar = MainTabBarAssembler.make(coordinator: self)
        tabBar.viewControllers = [makeHomeModule(), makeProfileModule()]
        self.rootVC = tabBar
        return tabBar
    }
    
    private func makeHomeModule() -> UIViewController {
        return .init()
        
        //FIXME: -

//        let coordinator = HomeCoordinator(container: container,
//                                          isCompletedNotification: false)
//        children.append(coordinator)
//        let vc = coordinator.start()
//        return vc
    }
    
    private func makeProfileModule() -> UIViewController {
        let coordinator = ProfileCoordinator(container: container)
        children.append(coordinator)
        let vc = coordinator.start()
        //FIXME: - зачем тут это?
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll()
            self?.rootVC?.dismiss(animated: true)
            self?.finish()
        }
        return vc
    }
}

extension MainTabBarCoordinator: MainTabBarCoordinatorProtocol {
    
    func showMenu(sender: UIView, delegat: MenuPopOverDelegate) {
        
        //FIXME: -

//        let menu = MenuPopOverBuilder.buildAddMenu(delegat: delegat,
//                                                   sourceView: sender)
//        rootVC?.present(menu, animated: true)
    }
    
    func showMenu(sender: UIView) {
        //FIXME: - удалить процедуру
    }

    func openNewCalendarNotification() {
        
        //FIXME: -

//        let coordinator = CreateDateNotificationCoordinator(container: container)
//        children.append(coordinator)
//        let vc = coordinator.start()
//        
//        coordinator.onDidFinish = { [weak self] coordinator in
//            self?.children.removeAll {coordinator == $0 }
//            vc.dismiss(animated: true)
//        }
//        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        
//        rootVC?.present(vc, animated: true)
    }
    
    func openNewTimerNotification() {
        
        //FIXME: -

//        let coordinator = CreateTimerNotificationCoordinator(container: container)
//        children.append(coordinator)
//        let vc = coordinator.start()
//        
//        coordinator.onDidFinish = { [weak self] coordinator in
//            self?.children.removeAll {coordinator == $0 }
//            vc.dismiss(animated: true)
//        }
//        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        
//        rootVC?.present(vc, animated: true)
    }
    
    func openNewLocationNotification() {
        
        //FIXME: -

//        let coordinator = CreateLocationNotificationCoordinator(container: container)
//        children.append(coordinator)
//        let vc = coordinator.start()
//        
//        coordinator.onDidFinish = { [weak self] coordinator in
//            self?.children.removeAll {coordinator == $0 }
//            vc.dismiss(animated: true)
//        }
//        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        
//        rootVC?.present(vc, animated: true)
    }
    
    
}

