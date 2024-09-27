//
//  MapPlanPointsCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 27.06.24.
//

import UIKit
import Storage

final class MapPlanPointsCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let vc = MapPlanPointsAssembler.make(container: container,
                                             coordinator: self)
        rootVC = vc
        return vc
    }
    
}

extension MapPlanPointsCoordinator: MapPlanPointsCoordinatorProtocol {
    
    func startIconModule() {
        let vc = IconViewVC()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        rootVC?.present(vc, animated: true)
    }
    
    func startCreatePlanPointModule(
        point: PlanPointDescription
    ) {
        openEditPlanPoint(point: point)
    }
    
    func startCategoriesPointModule(
        point: PlanPointDescription
    ) {
        openChooseCategoriesPoint(point: point)
    }
    
    private func openEditPlanPoint(point: PlanPointDescription) {

        let coordinator = CreatePlanPointCoordinator(
            container: container,
            point: point
        )
        children.append(coordinator)
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {coordinator == $0 }
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        
        rootVC?.present(vc, animated: true)
    }

    
    private func openChooseCategoriesPoint(point: PlanPointDescription) {

        let coordinator = ChooseCategoriesPointCoordinator(
            container: container,
            point: point
        )
        children.append(coordinator)
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {coordinator == $0 }
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        
        rootVC?.present(vc, animated: true)
    }
}
