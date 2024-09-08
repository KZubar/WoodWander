//
//  CategoriesPointDataWorker.swift
//  WoodWander
//
//  Created by k.zubar on 25.08.24.
//

import UIKit
import Storage

final class CategoriesPointDataWorker {

    typealias CompletionHandler = (Bool) -> Void
    
    private let storage: CategoriesPointStorage<CategoriesPointDTO>
        
    init(storage: CategoriesPointStorage<CategoriesPointDTO>) {
        self.storage = storage
    }
    
    //MARK: createOrUpdate
    func createOrUpdate(dto: (any DTODescriptionCategoriesPoint), completion: CompletionHandler? = nil) {
        storage.createOrUpdate(dto: dto)
    }
    
    //MARK: deleteByUser
    func deleteByUser(dto: (any DTODescriptionCategoriesPoint), completion: CompletionHandler? = nil) {
        storage.delete(dto: dto) { isSuccess in
            defer { completion?(isSuccess) }
            guard isSuccess else { return }
        }
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

    func createPredefinedDTO() {
        storage.createPredefinedDTO()
    }
    

}
