//
//  CreateCategoriesPointCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 25.08.24.
//

import UIKit
import Storage

final class CreateCategoriesPointCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private var dto: (any DTODescriptionCategoriesPoint)?
    
    init(container: Container) {
        self.container = container
    }
    
    init(container: Container, dto: (any DTODescriptionCategoriesPoint)?) {
        self.container = container
        self.dto = dto
    }

    override func start() -> UIViewController {
        let vc = CreateCategoriesPointAssembler.make(container: container,
                                                      dto: self.dto,
                                                      coordinator: self)
        rootVC = vc
        return vc
    }
}

extension CreateCategoriesPointCoordinator: CreateCategoriesPointCoordinatorProtocol { }
