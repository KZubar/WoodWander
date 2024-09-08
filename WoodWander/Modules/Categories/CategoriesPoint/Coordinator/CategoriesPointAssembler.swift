//
//  CategoriesPointAssembler.swift
//  WoodWander
//
//  Created by k.zubar on 22.08.24.
//

import UIKit
import Storage

final class CategoriesPointAssembler {
    
    private init() {}
    
    static func make(
        container: Container,
        coordinator: CategoriesPointCoordinatorProtocol
    ) -> UIViewController {
        
        let frcService = makeFRC()
        
        let adapter = CategoriesPointAdapter()
        
        let dataWorker: CategoriesPointDataWorker = container.resolve()
        
        //FIXME: - можно сотавить, но лучше убрать в другое место
        dataWorker.createPredefinedDTO()
        
        let vm = CategoriesPointVM(frcService: frcService,
                                   dataWorker: dataWorker,
                                   adapter: adapter,
                                   coordinator: coordinator)
        let vc = CategoriesPointVC(viewModel: vm)
        return vc
    }
    
    private static func makeFRC() -> FRCServiceCategoriesPoint<CategoriesPointDTO> {
        return .init { request in
            request.predicate = .CategoriesPoint.all
            request.sortDescriptors = [
                .CategoriesPoint.byPredefined,
                .CategoriesPoint.byIsDisabled,
                .CategoriesPoint.byDate,
                .CategoriesPoint.byName
            ]
        }
    }
}
