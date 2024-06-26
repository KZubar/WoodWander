//
//  AppCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit

final class AppCoordinator: Coordinator {
 
    private var container: Container
    private var windowsManager: WindowManager

    init(container: Container) {
        self.container = container
        self.windowsManager = container.resolve()
    }
    
    func startApp() {

        //FIXME: - временно, для отладки, потом закомментировать
        openMainApp()
        
        //FIXME: - временно, для отладки, потом разкомментировать
//        if ParametersHelper.get(.authenticated) == false {
//            openAuthModule()
//        } else if ParametersHelper.get(.onboarded) == false {
//            openOnboardingModule()
//        } else {
//            openMainApp()
//        }
    }
    
    private func openAuthModule() {
//        let coordinator = LoginCoordinator(container: container)
//        
//        self.children.append(coordinator)
//
//        coordinator.onDidFinish = { [weak self] coordinator in
//            self?.children.removeAll { $0 == coordinator}
//            self?.startApp()
//        }
//
//        let vc = coordinator.start()
//        
//        let window = windowsManager.get(type: .main)
//        window.rootViewController = vc
//        windowsManager.show(type: .main)
    }
    
    private func openOnboardingModule() {
//        let coordinator = OnboardFirstStepCoordinator()
//        
//        self.children.append(coordinator)
//
//        coordinator.onDidFinish = { [weak self] coordinator in
//            self?.children.removeAll { $0 == coordinator}
//            self?.startApp()
//        }
//
//        let vc = coordinator.start()
//
//        let window = windowsManager.get(type: .main)
//        window.rootViewController = vc
//        windowsManager.show(type: .main)
    }
    
    private func openMainApp() {
        let coordinator = MainTabBarCoordinator(container: container)
        
        self.children.append(coordinator)

        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll { $0 == coordinator}
            self?.startApp()
        }

        let vc = coordinator.start()
        
        let window = windowsManager.get(type: .main)
        window.rootViewController = vc
        windowsManager.show(type: .main)
    }

}
