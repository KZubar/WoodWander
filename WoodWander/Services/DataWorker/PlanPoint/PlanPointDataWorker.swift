//
//  PlanPointDataWorker.swift
//  WoodWander
//
//  Created by k.zubar on 30.07.24.
//

import Foundation
import Storage


final class PlanPointDataWorker {
    
    typealias CompletionHandler = (Bool) -> Void
    
    private let storage: PlanPointStorage<PlanPointDTO>
//    private let backupService: FirebaseBackupService
//    private let notificationService: NotificationServiceDataWorkerUseCase

//    init(backupService: FirebaseBackupService,
//         storage: PlanPointStorage<PlanPointDTO>,
//         notificationService: NotificationServiceDataWorkerUseCase
//    ) {
//        self.backupService = backupService
//        self.storage = storage
//        self.notificationService = notificationService
//    }
    
    init(storage: PlanPointStorage<PlanPointDTO>) { 
        self.storage = storage
    }
    
    //MARK: createOrUpdate
    func createOrUpdate(dto: (any DTODescriptionPlanPoint), completion: CompletionHandler? = nil) {
        storage.createOrUpdate(dto: dto)
//        storage.createOrUpdate(dto: dto) { [notificationService, backupService] isSuccess in
//            defer { completion?(isSuccess) }
//            
//            guard isSuccess else { return }
//            
//            //используем сильные ссылки для захвата
//            notificationService.makeNotificaions(from: [dto])
//            backupService.backup(dto: dto)
//        }
    }
    
    //MARK: deleteByUser
    func deleteByUser(dto: (any DTODescriptionPlanPoint), completion: CompletionHandler? = nil) {
//        storage.delete(dto: dto) { [notificationService, backupService] isSuccess in
//            defer { completion?(isSuccess) }
//            
//            guard isSuccess else { return }
//            
//            //используем сильные ссылки для захвата
//            notificationService.removeNotifications(id: [dto.id])
//            backupService.delete(id: dto.id)
//        }
    }
    
    //MARK: deleteAllByLogout
    func deleteAllByLogout(completion: CompletionHandler? = nil) {
//        let allDTO = storage.fetch()
//        let allId = allDTO.map { $0.id }
//        
//        notificationService.removeNotifications(id: allId)
//        storage.deleteAll(dtos: allDTO, completion: completion)
    }
    
    //MARK: restore
    func restore(completion: CompletionHandler? = nil) {
//        backupService.loadBackup { [weak self] dtos in
//            self?.storage.createDTOs(dtos: dtos) { isSuccess in
//                defer { completion? (isSuccess) }
//                
//                guard isSuccess else { return }
//                
//                self?.notificationService.makeNotificaions(from: dtos)
//            }
//        }
    }

    
}
