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
    private let storagePPCategories: PPCategoriesStorage<PPCategoriesDTO>
    
    init(storage: PlanPointStorage<PlanPointDTO>,
         storagePPCategories: PPCategoriesStorage<PPCategoriesDTO>
    ) {
        self.storage = storage
        self.storagePPCategories = storagePPCategories
    }
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionPlanPoint] {
        return storage.fetch(predicate: predicate,
                             sortDescriptors: sortDescriptors)
    }
    
    public func fetchDTO(predicate: NSPredicate? = nil,
                         sortDescriptors: [NSSortDescriptor] = []
    ) -> [PlanPointDTO] {
        return storage.fetchDTO(predicate: predicate,
                                sortDescriptors: sortDescriptors)
    }
    
    public func fetchPPCategories(predicate: NSPredicate? = nil,
                                  sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionPPCategories] {
        return storagePPCategories.fetch(predicate: predicate,
                                         sortDescriptors: sortDescriptors)
    }
    
    public func fetchPPCategoriesDTO(predicate: NSPredicate? = nil,
                                     sortDescriptors: [NSSortDescriptor] = []
    ) -> [PPCategoriesDTO] {
        return storagePPCategories.fetchDTO(predicate: predicate,
                                            sortDescriptors: sortDescriptors)
    }
    
    //MARK: createOrUpdate
    func createOrUpdate(dto: (any DTODescriptionPlanPoint),
                        completion: CompletionHandler? = nil
    ) {
        storage.createOrUpdate(dto: dto)
    }
    
    //MARK: deleteByUser
    func deleteByUser(dto: (any DTODescriptionPlanPoint), completion: CompletionHandler? = nil) {
        //1. удаляем связи точки с категорией
        storagePPCategories.deleteForPoint(dto: dto) // результат не важен, потом будет процедура чистки
        //2. удаляем точку
        storage.delete(dto: dto) { isSuccess in
            defer { completion?(isSuccess) }
            guard isSuccess else { return }
        }
    }


    
}
