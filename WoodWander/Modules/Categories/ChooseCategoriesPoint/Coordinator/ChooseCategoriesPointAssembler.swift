//
//  ChooseCategoriesPointAssembler.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit
import Storage

final class ChooseCategoriesPointAssembler {
    
    private init() {}
    
    static func make(
        container: Container,
        coordinator: ChooseCategoriesPointCoordinatorProtocol,
        point: PlanPointDescription
    ) -> UIViewController {
        
        let frcService = makeFRC()

        let dataWorker: PPCategoriesDataWorker = container.resolve()

        let adapter = ChooseCategoriesPointAdapter()


        let vm = ChooseCategoriesPointVM(frcService: frcService,
                                         point: point,
                                         adapter: adapter,
                                         coordinator: coordinator,
                                         dataWorker: dataWorker)
        
        let vc = ChooseCategoriesPointVC(viewModel: vm)
        return vc
    }

    private static func makeFRC() -> FRCServiceCategoriesPoint<CategoriesPointDTO> {
        return .init { request in
            request.predicate = .CategoriesPoint.all
            request.sortDescriptors = [
                .CategoriesPoint.byPredefined,
                .CategoriesPoint.byDate,
                .CategoriesPoint.byIsDisabled,
                .CategoriesPoint.byName
            ]
        }
    }
}
