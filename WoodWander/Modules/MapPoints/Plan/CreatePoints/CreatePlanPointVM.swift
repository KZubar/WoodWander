//
//  CreatePlanPointVM.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import UIKit
import Storage
import CoreLocation

protocol CreatePlanPointCoordinatorProtocol: AnyObject {
    func finish()
}

protocol CreatePlanPointDataWorkerUseCase {
    typealias CompletionHandler = (Bool) -> Void
    func createOrUpdate(dto: (any DTODescriptionPlanPoint), completion: CompletionHandler?)
}

final class CreatePlanPointVM: CreatePlanPointViewModelProtocol {

    private let dataWorker: CreatePlanPointDataWorkerUseCase

    private weak var coordinator: CreatePlanPointCoordinatorProtocol?
    private var dto: (any DTODescriptionPlanPoint)?

    var point: PlanPointDescription?
    
    init(coordinator: CreatePlanPointCoordinatorProtocol,
         point: PlanPointDescription?,
         dataWorker: CreatePlanPointDataWorkerUseCase) {
        
        self.coordinator = coordinator
        self.dataWorker = dataWorker
        self.point = point
        bind()
    }
    
    private func bind() { }
    
    func createDidTap() {
//        guard checkValidation() else { return }
//        
        guard let point else { return }

        
        
        let id = point.uuid.isEmpty ? UUID().uuidString : point.uuid
        
        self.dto = PlanPointDTO(uuid: id,
                                date: point.date,
                                latitude: point.latitude,
                                longitude: point.longitude,
                                name: point.name,
                                descr: point.descr,
                                isDisabled: point.isDisabled,
                                oblast: point.oblast,
                                region: point.region,
                                regionInMeters: point.regionInMeters,
                                radiusInMeters: point.radiusInMeters,
                                color: point.color,
                                icon: point.icon,
                                imagePathStr: point.imagePathStr)

 
        var dtoPoint = self.dto as? PlanPointDTO
        
        //FIXME: - delete
        dtoPoint?.date = Date()
        dtoPoint?.imagePathStr = ""
        dtoPoint?.oblast = ""
        dtoPoint?.region = ""
        

        guard let dtoSave = dtoPoint else { return }

        self.dataWorker.createOrUpdate(dto: dtoSave) { _ in }
        self.coordinator?.finish()

    }
    
    func dismissDidTap() {
        coordinator?.finish()
    }
    
}
