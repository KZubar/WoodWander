//
//  CategoriesPointStorage.swift
//  Storage
//
//  Created by k.zubar on 25.08.24.
//

import Foundation
import CoreData

public enum CategoriesPointPredefined {
    
    case favorites
    
    case marked

    var uuid: String {
        switch self {
        case .favorites: return "00000000-0000-0000-0000-000000000001"
        case .marked: return "00000000-0000-0000-0000-000000000002"
        }
    }

    var name: String {
        switch self {
        case .favorites: return "Избранное"
        case .marked: return "Отмеченное"
        }
    }

    var icon: String {
        switch self {
        case .favorites: return "❤️"
        case .marked: return "🩵"
        }
    }
    
}

public class CategoriesPointStorage<DTO: DTODescriptionCategoriesPoint> {
    
    public typealias CompletionHandler = (Bool) -> Void
    public init() { }
    
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

    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionCategoriesPoint] {
        let context = CoreDataService.shared.backgroundContext
        return fetchMO(
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            context: context
        )
        .compactMap { $0.toDTO() }
    }

    public func fetchDTO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [CategoriesPointDTO] {
        
        return fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? CategoriesPointDTO}
    }

    public func create(
        dto: (any DTODescriptionCategoriesPoint),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform {
            let mo = dto.createMO(context: context)
            if let _ = mo?.uuid {
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            }
        }
        
    }

    public func createPredefinedDTO() {
        
        let fa = CategoriesPointPredefined.favorites
        let dtoFavourites = CategoriesPointDTO(color: "",
                                               date: Date(),
                                               descr: "",
                                               icon: fa.icon,
                                               isDisabled: false,
                                               name: fa.name,
                                               predefined: true,
                                               uuid: fa.uuid)
        
        let ma = CategoriesPointPredefined.marked
        let dtoMarked = CategoriesPointDTO(color: "",
                                           date: Date(),
                                           descr: "",
                                           icon: ma.icon,
                                           isDisabled: false,
                                           name: ma.name,
                                           predefined: true,
                                           uuid: ma.uuid)
        
        let context = CoreDataService.shared.backgroundContext
        if fetchMO(
            predicate: .CategoriesPoint.category(byUuid: dtoFavourites.uuid),
            context: context
        ).isEmpty {
            create(dto: dtoFavourites)
        }
        if fetchMO(
            predicate: .CategoriesPoint.category(byUuid: dtoMarked.uuid),
            context: context
        ).isEmpty {
            create(dto: dtoMarked)
        }
    }
    
    public func createDTOs(
        dtos: [(any DTODescriptionCategoriesPoint)],
        completion: CompletionHandler? = nil
     ) {
         let context = CoreDataService.shared.backgroundContext
         context.perform {
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

    public func update(dto: (any DTODescriptionCategoriesPoint),
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let mo = self?.fetchMO(
                    predicate: .CategoriesPoint.category(byUuid: dto.uuid),
                    context: context
                ).first
            else { return }
            mo.apply(dto: dto)
            
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
    }
    
    public func updateDTOs(dtos: [any DTODescriptionCategoriesPoint],
                           completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        let uuids = dtos.map { $0.uuid }
        context.perform { [weak self] in
            guard let mos = self?.fetchMO(predicate: .CategoriesPoint.categories(in: uuids),
                                          context: context)
            else { return }
            mos.forEach { model in
                guard
                    let dto = dtos.first(where: { $0.uuid == model.uuid } )
                else { return }
                model.apply(dto: dto)
            }
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
        
        
    }
    
    public func delete(dto: (any DTODescriptionCategoriesPoint), completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let mo = self?.fetchMO(
                    predicate: .CategoriesPoint.category(byUuid: dto.uuid),
                    context: context
                ).first
            else { return }
            
            context.delete(mo)
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }
    
    public func deleteAll(dtos: [any DTODescriptionCategoriesPoint],
                          completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let uuids = dtos.map{ $0.uuid }
            let mos = self?.fetchMO(
                predicate: .CategoriesPoint.categories(in: uuids),
                context: context
            )
            mos?.forEach { context.delete($0) }
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }

    public func createOrUpdate(
        dto: (any DTODescriptionCategoriesPoint),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        if fetchMO(
            predicate: .CategoriesPoint.category(byUuid: dto.uuid),
            context: context
        ).isEmpty {
            create(dto: dto, completion: completion)
        } else {
            update(dto: dto, completion: completion)
        }
    }
}
