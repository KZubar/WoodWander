//
//  SourcePointStorage.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//

import Foundation
import CoreData

public class SourcePointStorage<DTO: DTODescriptionSourcePoint> {
    
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
    ) -> [any DTODescriptionSourcePoint] {
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
    ) -> [SourcePointDTO] {
        
        return fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? SourcePointDTO}
    }

    public func create(
        dto: (any DTODescriptionSourcePoint),
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
    
    public func createDTOs(
        dtos: [(any DTODescriptionSourcePoint)],
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

    public func update(dto: (any DTODescriptionSourcePoint),
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let mo = self?.fetchMO(
                    predicate: .SourcePoint.source(byUuid: dto.uuid),
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
    
    public func updateDTOs(dtos: [any DTODescriptionSourcePoint],
                           completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        let uuids = dtos.map { $0.uuid }
        context.perform { [weak self] in
            guard let mos = self?.fetchMO(predicate: .SourcePoint.sources(in: uuids),
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
    
    public func delete(dto: (any DTODescriptionSourcePoint), completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let mo = self?.fetchMO(
                    predicate: .SourcePoint.source(byUuid: dto.uuid),
                    context: context
                ).first
            else { return }
            
            context.delete(mo)
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }
    
    public func deleteAll(dtos: [any DTODescriptionSourcePoint],
                          completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let uuids = dtos.map{ $0.uuid }
            let mos = self?.fetchMO(
                predicate: .SourcePoint.sources(in: uuids),
                context: context
            )
            mos?.forEach { context.delete($0) }
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }

    public func createOrUpdate(
        dto: (any DTODescriptionSourcePoint),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        if fetchMO(
            predicate: .SourcePoint.source(byUuid: dto.uuid),
            context: context
        ).isEmpty {
            create(dto: dto, completion: completion)
        } else {
            update(dto: dto, completion: completion)
        }
    }
}
