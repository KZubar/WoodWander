//
//  CreatePlanPointAssembler.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit
import Storage

final class CreatePlanPointAssembler {
    
    private init() {}
    
    static func make(
        container: Container,
        point: PlanPointDescription?,
        coordinator: CreatePlanPointCoordinatorProtocol
    ) -> UIViewController {
        
        let dataWorker: PlanPointDataWorker = container.resolve()
        
        let vm = CreatePlanPointVM(coordinator: coordinator,
                                   point: point,
                                   dataWorker: dataWorker)
        
        return CreatePlanPointVC(viewModel: vm)
    }
}
