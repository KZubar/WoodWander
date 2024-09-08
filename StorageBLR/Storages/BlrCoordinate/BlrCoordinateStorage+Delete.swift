//
//  BlrCoordinateStorage+Delete.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//

import Foundation
import CoreData

extension BlrCoordinateStorage {
    
    public func delete(
        dto: (any DTODescriptionCoordinateBLR),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        
        context.perform { [weak self] in
            
            //Найдем MO для BLR
            guard
                //let blrDTO: BlrDTO = dto.blr,
                //let blrGid: String = blrDTO.gid,
                let blrPredicate: NSPredicate = dto.blr?.predicate
            else { return }
            if let blrMO = AllBlrStorage()
                .fetchMO(
                    predicate: blrPredicate,
                    context: context
                )
                .first
            {
                guard
                    let mo = self?.fetchMO(
                        predicate: .BlrCoordinate.byBLR(in: blrMO)
                    ).first
                else { return }
                
                context.delete(mo)
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            }
        }
    }
    
    public func deleteAll(
        dtos: [any DTODescriptionCoordinateBLR],
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform { [weak self] in
            let mos = self?.fetchMO()
            mos?.forEach { context.delete($0) }
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
    }

}
