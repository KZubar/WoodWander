//
//  BlrCoordinateStorage+Create.swift
//  StorageBLR
//
//  Created by k.zubar on 6.07.24.
//

import Foundation
import CoreData

extension BlrCoordinateStorage {

    public func create(
        dto: (any DTODescriptionCoordinateBLR),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform {
            let _ = dto.createMO(context: context)
            CoreDataService.shared.saveContext(
                context: context,
                completion: completion
            )
        }
        
    }

    public func createDTOs(
        dtos: [(any DTODescriptionCoordinateBLR)],
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

}
