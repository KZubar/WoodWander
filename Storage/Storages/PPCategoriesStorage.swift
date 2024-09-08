//
//  PPCategoriesStorage.swift
//  Storage
//
//  Created by k.zubar on 1.09.24.
//

import Foundation
import CoreData

public class PPCategoriesStorage<DTO: DTODescriptionPPCategories> {
    
    public typealias CompletionHandler = (Bool) -> Void
    public init() { }
    
    //+++
    private func fetchMO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        context: NSManagedObjectContext
    ) -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        //let context = CoreDataService.shared.mainContext
        
        let result = try? context.fetch(request)
        return result ?? []
    }
    
    //+++
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionPPCategories] {
        let context = CoreDataService.shared.backgroundContext
        return fetchMO(
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            context: context
        )
        .compactMap { $0.toDTO() }
    }
    
    //+++
    public func fetchDTO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [PPCategoriesDTO] {
        return fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? PPCategoriesDTO}
    }
    
    //+++
//    public func create(
//        dto: (any DTODescriptionPPCategories),
//        completion: CompletionHandler? = nil
//    ) {
//        let context = CoreDataService.shared.backgroundContext
//        context.perform {
//            let mo = dto.createMO(context: context)
//            if let _ = mo?.uuidPoint, let _ = mo?.uuidCategory {
//                CoreDataService.shared.saveContext(
//                    context: context,
//                    completion: completion
//                )
//            }
//        }
//        
//    }
    
    //+++
//    public func createDTOs(
//        dtos: [(any DTODescriptionPPCategories)],
//        completion: CompletionHandler? = nil
//    ) {
//        let context = CoreDataService.shared.backgroundContext
//        context.perform {
//            let mos = dtos.map {
//                $0.createMO(context: context)
//            }
//            if mos.count > 0 {
//                CoreDataService.shared.saveContext(
//                    context: context,
//                    completion: completion
//                )
//            }
//            
//        }
//        
//    }
    
    //+++
//    public func update(dto: (any DTODescriptionPPCategories),
//                       completion: CompletionHandler? = nil) {
//        let context = CoreDataService.shared.backgroundContext
//        context.perform { [weak self] in
//            guard
//                let mo = self?.fetchMO(
//                    predicate: .PPCategories.point(
//                        byUuidPoin: dto.uuidPoint,
//                        byUuidCategory: dto.uuidCategory
//                    ),
//                    context: context
//                ).first
//            else { return }
//            mo.apply(dto: dto)
//            
//            CoreDataService.shared.saveContext(
//                context: context,
//                completion: completion
//            )
//        }
//    }
    
    //    public func updateDTOs(dtos: [any DTODescriptionPPCategories],
    //                           completion: CompletionHandler? = nil) {
    //        let context = CoreDataService.shared.backgroundContext
    //        let uuids = dtos.map { (point: $0.uuidPoint, category: $0.uuidCategory)  }
    //        context.perform { [weak self] in
    //            guard let mos = self?.fetchMO(predicate: .PPCategories.points(in: uuids),
    //                                          context: context)
    //            else { return }
    //            mos.forEach { model in
    //                guard
    //                    let dto = dtos.first(where: { $0.uuidPoint == model.uuidPoint &&  $0.uuidCategory == model.uuidCategory} )
    //                else { return }
    //                model.apply(dto: dto)
    //            }
    //            CoreDataService.shared.saveContext(context: context,
    //                                               completion: completion)
    //        }
    //
    //
    //    }
    
    //+++
//    public func delete(dto: (any DTODescriptionPPCategories),
//                       completion: CompletionHandler? = nil) {
//        let context = CoreDataService.shared.backgroundContext
//        context.perform { [weak self] in
//            guard
//                let mo = self?.fetchMO(
//                    predicate: .PPCategories.point(
//                        byUuidPoin: dto.uuidPoint,
//                        byUuidCategory: dto.uuidCategory
//                    ),
//                    context: context
//                ).first
//            else { return }
//            
//            context.delete(mo)
//            CoreDataService.shared.saveContext(context: context,
//                                               completion: completion)
//        }
//    }
    
    public func deleteAll(dtoPoint: (any DTODescriptionPlanPoint),
                          completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let mos = self?.fetchMO(
                predicate: .PPCategories.categories(byUuidPoin: dtoPoint.uuid),
                context: context
            )
            if (mos?.count ?? 0) > 0 {
                mos?.forEach { context.delete($0) }
                CoreDataService.shared.saveContext(context: context,
                                                   completion: completion)
            } else {
                completion?(true)
            }
        }
    }

    //    public func deleteAll(dtos: [any DTODescriptionPPCategories],
    //                          completion: CompletionHandler? = nil) {
    //        let context = CoreDataService.shared.backgroundContext
    //        context.perform { [weak self] in
    //            let uuids = dtos.map { (point: $0.uuidPoint, category: $0.uuidCategory)  }
    //            let mos = self?.fetchMO(
    //                predicate: .PPCategories.points(in: uuids),
    //                context: context
    //            )
    //            mos?.forEach { context.delete($0) }
    //            CoreDataService.shared.saveContext(context: context,
    //                                               completion: completion)
    //        }
    //    }

    
    
    //    //+++ --- вроде проверено, вроде не используется
    //    public func createOrUpdate(
    //        dto: (any DTODescriptionPPCategories),
    //        completion: CompletionHandler? = nil
    //    ) {
    //        let context = CoreDataService.shared.backgroundContext
    //        if fetchMO(
    //            predicate: .PPCategories.point(
    //                byUuidPoin: dto.uuidPoint,
    //                byUuidCategory: dto.uuidCategory
    //            ),
    //            context: context
    //        ).isEmpty {
    //            create(dto: dto, completion: completion)
    //        } else {
    //            update(dto: dto, completion: completion)
    //        }
    //    }
    
    public func create(
        dto: (any DTODescriptionPlanPoint),
        dtos: [(any DTODescriptionPPCategories)],
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        
        let mos = dtos.map {
            $0.createMO(context: context)
        }
        if mos.count > 0 {
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
    }
    

}
