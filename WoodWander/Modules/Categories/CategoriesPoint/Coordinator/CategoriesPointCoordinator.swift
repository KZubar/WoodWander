//
//  CategoriesPointCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 22.08.24.
//

import UIKit
import Storage

final class CategoriesPointCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let vc = CategoriesPointAssembler.make(container: container, coordinator: self)
        rootVC = vc
        return vc
    }
    
}

extension CategoriesPointCoordinator: CategoriesPointCoordinatorProtocol {
        
    func showMenu(
        dto: (any DTODescriptionCategoriesPoint)?,
        completion: CompletionHandler?
    ) {
        //        let menu = MenuPopOverBuilder.buildEditMenu(delegat: delegat,
        //                                                    sourceView: sender)
        //        rootVC?.present(menu, animated: true)
        //FIXME: -
        
        var menuItems = [
            CategoriesPointMenuAction.disabled,
            CategoriesPointMenuAction.edit,
            CategoriesPointMenuAction.share]
        
        if (dto?.predefined ?? false) == false {
            menuItems.append(CategoriesPointMenuAction.delete)
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for item in menuItems {
            let action = UIAlertAction(title: item.title, style: .default) { _ in
                completion?(item)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        //alertController.view.tintColor = UIColor.appRed
        cancelAction.titleTextColor = .red
        
        alertController.addAction(cancelAction)

        rootVC?.present(alertController, animated: true) {
            
        }
        
    
    }
    
    func openEditCategoriesPoint(dto: (any DTODescriptionCategoriesPoint)?) {
        
        let coordinator = CreateCategoriesPointCoordinator(
            container: container,
            dto: dto)
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
