//
//  CreatePlanPointCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit
import Storage

final class CreatePlanPointCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private var point: PlanPointDescription?
    
    init(container: Container) {
        self.container = container
    }
    
    init(container: Container, point: PlanPointDescription) {
        self.container = container
        self.point = point
    }

    override func start() -> UIViewController {
            
        let vc = CreatePlanPointAssembler.make(container: container,
                                               point: self.point,
                                               coordinator: self)
        rootVC = vc
        return vc
    }
}

extension CreatePlanPointCoordinator: CreatePlanPointCoordinatorProtocol { }

