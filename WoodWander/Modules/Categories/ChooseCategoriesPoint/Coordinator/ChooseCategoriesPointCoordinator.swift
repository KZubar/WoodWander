//
//  ChooseCategoriesPointCoordinator.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit
import Storage

final class ChooseCategoriesPointCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private var point: PlanPointDescription
    private weak var delegateVM: MapPlanPointsViewModelDelegat?

    init(container: Container,
         point: PlanPointDescription,
         delegateVM: MapPlanPointsViewModelDelegat?) {
        self.container = container
        self.point = point
        self.delegateVM = delegateVM
    }
    
    override func start() -> UIViewController {
        let vc = ChooseCategoriesPointAssembler.make(container: container,
                                                     coordinator: self,
                                                     point: self.point,
                                                     delegateVM: self.delegateVM)
        rootVC = vc
        return vc
    }
    
}

extension ChooseCategoriesPointCoordinator: ChooseCategoriesPointCoordinatorProtocol {
    
    func showQuestionFinishViewControler(completion: ((Bool) -> Void)?) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let refusedAction = UIAlertAction(
            title: "Отменить изменения",
            style: .default) { _ in
                completion?(true)
            }
        refusedAction.titleTextColor = .red
        alertController.addAction(refusedAction)
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)

        rootVC?.present(alertController, animated: true) 
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

