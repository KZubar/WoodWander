//
//  BlrStorage+Delete.swift
//  Storage
//
//  Created by k.zubar on 3.07.24.
//

import Foundation
import CoreData

extension BlrStorage {
    
    //delete0
    public func delete0(
        dto: (any DTODescriptionBLR),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let byId = dto.gid_0
            else { return }

            guard
                let mo = self?.fetchMO(
                    predicate: .BLR.blr0(byId: byId),
                    context: context
                ).first
            else { return }
            
            context.delete(mo)
            
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
    }
    
    //delete1
    public func delete1(
        dto: (any DTODescriptionBLR),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let byId = dto.gid_1
            else { return }

            guard
                let mo = self?.fetchMO(
                    predicate: .BLR.blr1(byId: byId),
                    context: context
                ).first
            else { return }
            
            context.delete(mo)
            
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
    }
    
    //delete2
    public func delete2(
        dto: (any DTODescriptionBLR),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            guard
                let byId = dto.gid_2
            else { return }

            guard
                let mo = self?.fetchMO(
                    predicate: .BLR.blr2(byId: byId),
                    context: context
                ).first
            else { return }
            
            context.delete(mo)
            
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
    }

    //deleteAll
    public func deleteAll(completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let mos = self?.fetchMO(
                predicate: .BLR.all,
                context: context
            )
            if let count = mos?.count, count > 0 {
                mos?.forEach { context.delete($0) }
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            } else {
                completion?(true)
            }
        }
    }

    //delete0All
    public func delete0All(
        dtos: [any DTODescriptionBLR],
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let uuids = dtos.compactMap{ $0.gid_0 }
            if !uuids.isEmpty {
                let mos = self?.fetchMO(
                    predicate: .BLR.blr0s(in: uuids),
                    context: context
                )
                mos?.forEach { context.delete($0) }
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            }
        }
    }

    //delete1All
    public func delete1All(
        dtos: [any DTODescriptionBLR],
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let uuids = dtos.compactMap{ $0.gid_1 }
            if !uuids.isEmpty {
                let mos = self?.fetchMO(
                    predicate: .BLR.blr1s(in: uuids),
                    context: context
                )
                mos?.forEach { context.delete($0) }
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            }
        }
    }

    //delete2All
    public func delete2All(
        dtos: [any DTODescriptionBLR],
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let uuids = dtos.compactMap{ $0.gid_2 }
            if !uuids.isEmpty {
                let mos = self?.fetchMO(
                    predicate: .BLR.blr2s(in: uuids),
                    context: context)
                mos?.forEach { context.delete($0) }
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            }
        }
    }

}
