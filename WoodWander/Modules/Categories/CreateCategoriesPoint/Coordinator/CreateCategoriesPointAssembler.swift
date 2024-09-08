//
//  CreateCategoriesPointAssembler.swift
//  WoodWander
//
//  Created by k.zubar on 25.08.24.
//

import UIKit
import Storage

final class CreateCategoriesPointAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     dto: (any DTODescriptionCategoriesPoint)?,
                     coordinator: CreateCategoriesPointCoordinatorProtocol) -> UIViewController {
        
        let dataWorker: CategoriesPointDataWorker = container.resolve()
        
        let vm = CreateCategoriesPointVM(coordinator: coordinator,
                                          dto: dto,
                                          dataWorker: dataWorker)
        
        return CreateCategoriesPointVC(viewModel: vm)
    }
}
