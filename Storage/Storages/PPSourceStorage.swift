//
//  PPSourceStorage.swift
//  Storage
//
//  Created by k.zubar on 1.10.24.
//

import Foundation
import CoreData

public class PPSourceStorage<DTO: DTODescriptionPPSource> {
    
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
    ) -> [any DTODescriptionPPSource] {
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
    ) -> [PPSourceDTO] {
        return fetch(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ).compactMap { $0 as? PPSourceDTO}
    }
    
    //+++ проверенно
    public func deleteForSource(dto: (any DTODescriptionSourcePoint),
                                completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let mos = self?.fetchMO(
                predicate: .PPSource.points(byUuidSource: dto.uuid),
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
    
    //+++ проверенно
    public func deleteForPoint(dto: (any DTODescriptionPlanPoint),
                               completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let mos = self?.fetchMO(
                predicate: .PPSource.sources(byUuidPoin: dto.uuid),
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
    
    public func create(
        dto: (any DTODescriptionPlanPoint),
        dtos: [(any DTODescriptionPPSource)],
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
