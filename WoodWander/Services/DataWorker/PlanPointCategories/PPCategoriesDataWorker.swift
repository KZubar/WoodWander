//
//  PPCategoriesDataWorker.swift
//  WoodWander
//
//  Created by k.zubar on 2.09.24.
//

import Foundation
import Storage


final class PPCategoriesDataWorker {
    
    typealias CompletionHandler = (Bool) -> Void
    
    private let storage: PPCategoriesStorage<PPCategoriesDTO>
    private let storagePlanPoint: PlanPointStorage<PlanPointDTO>
    
    init(storage: PPCategoriesStorage<PPCategoriesDTO>,
         storagePlanPoint: PlanPointStorage<PlanPointDTO>) {
        self.storage = storage
        self.storagePlanPoint = storagePlanPoint
    }
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionPPCategories] {
        return storage.fetch(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    public func fetchDTO(predicate: NSPredicate? = nil,
                         sortDescriptors: [NSSortDescriptor] = []
    ) -> [PPCategoriesDTO] {
        return storage.fetchDTO(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    //MARK:
    public func create(dtoPoint: (any DTODescriptionPlanPoint),
                       dtosPPCategories: [any DTODescriptionPPCategories],
                       completion: CompletionHandler? = nil
    ) {
        //создадим или обновим dtoPoint
        storagePlanPoint.createOrUpdate(dto: dtoPoint) { [storage] isSuccess in
            guard isSuccess else { completion?(false); return }

            //всегда удаляем dtosPPCategories
            storage.deleteAll(dtoPoint: dtoPoint) { isSuccess in
                guard isSuccess else { completion?(false); return }
                
                //потом создаем dtosPPCategories
                storage.create(dto: dtoPoint, dtos: dtosPPCategories) { isSuccess in
                    defer { completion?(isSuccess) }
                    guard isSuccess else { return }
                }
            }
        }
    }
    
//    //MARK: deleteByUser
//    func deleteByUser(dto: (any DTODescriptionPlanPoint), completion: CompletionHandler? = nil) {
////        storage.delete(dto: dto) { [notificationService, backupService] isSuccess in
////            defer { completion?(isSuccess) }
////
////            guard isSuccess else { return }
////
////            //используем сильные ссылки для захвата
////            notificationService.removeNotifications(id: [dto.id])
////            backupService.delete(id: dto.id)
////        }
//    }
    
//    //MARK: deleteAllByLogout
//    func deleteAllByLogout(completion: CompletionHandler? = nil) {
////        let allDTO = storage.fetch()
////        let allId = allDTO.map { $0.id }
////
////        notificationService.removeNotifications(id: allId)
////        storage.deleteAll(dtos: allDTO, completion: completion)
//    }
    
//    //MARK: restore
//    func restore(completion: CompletionHandler? = nil) {
////        backupService.loadBackup { [weak self] dtos in
////            self?.storage.createDTOs(dtos: dtos) { isSuccess in
////                defer { completion? (isSuccess) }
////
////                guard isSuccess else { return }
////
////                self?.notificationService.makeNotificaions(from: dtos)
////            }
////        }
//    }

    
}
