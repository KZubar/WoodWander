//
//  PointStorage.swift
//  Storage
//
//  Created by k.zubar on 26.06.24.
//

import Foundation
import CoreData

public class PointStorage<DTO: DTODescriptionPoint> {
    
    public typealias CompletionHandler = (Bool) -> Void
    public init() { }
    
    private func fetchMO(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        context: NSManagedObjectContext = CoreDataService.shared.mainContext
    ) -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        //let context = CoreDataService.shared.mainContext
        
        let result = try? context.fetch(request)
        return result ?? []
    }

    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescriptionPoint] {
        return fetchMO(predicate: predicate,
                       sortDescriptors: sortDescriptors)
        .compactMap { $0.toDTO() }
    }

    public func create(dto: (any DTODescriptionPoint),
                       completion: CompletionHandler? = nil) {
        let contex = CoreDataService.shared.backgroundContext
        contex.perform {
            let mo = dto.createMO(context: contex)
            CoreDataService.shared.saveContext(context: contex,
                                               completion: completion)
        }
        
    }

    public func createDTOs(
        dtos: [(any DTODescriptionPoint)],
        completion: CompletionHandler? = nil
     ) {
        let contex = CoreDataService.shared.backgroundContext
        contex.perform {
            let mos = dtos.map {
                $0.createMO(context: contex)
            }
            CoreDataService.shared.saveContext(context: contex,
                                               completion: completion)
        }
        
    }

    public func update(dto: (any DTODescriptionPoint),
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let mo = self?.fetchMO(
                    predicate: .Point.point(byUuid: dto.uuid),
                    context: context
                ).first
            else { return }
            mo.apply(dto: dto)
            
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }
    
    public func updateDTOs(dtos: [any DTODescriptionPoint],
                           completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        let uuids = dtos.map { $0.uuid }
        context.perform { [weak self] in
            guard let mos = self?.fetchMO(predicate: .Point.points(in: uuids),
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
    
    public func delete(dto: (any DTODescriptionPoint),
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let mo = self?.fetchMO(
                    predicate: .Point.point(byUuid: dto.uuid),
                    context: context
                ).first
            else { return }
            
            context.delete(mo)
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }
    
    public func deleteAll(dtos: [any DTODescriptionPoint],
                          completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let uuids = dtos.map{ $0.uuid }
            let mos = self?.fetchMO(
                predicate: .Point.points(in: uuids),
                context: context
            )
            mos?.forEach(context.delete)
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }

    public func createOrUpdate(dto: (any DTODescriptionPoint),
                               completion: CompletionHandler? = nil
    ) {
        if fetchMO(predicate: .Point.point(byUuid: dto.uuid)).isEmpty {
            create(dto: dto, completion: completion)
        } else {
            update(dto: dto, completion: completion)
        }
    }
}
