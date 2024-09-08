//
//  BlrStorage+Create.swift
//  Storage
//
//  Created by k.zubar on 3.07.24.
//

import Foundation
import CoreData

extension BlrStorage {

    //create
    public func create(
        dto: (any DTODescriptionBLR),
        completion: CompletionHandler? = nil
    ) {
        let context = CoreDataService.shared.backgroundContext
        context.perform {
            if let _ = dto.createMO(context: context) {
                CoreDataService.shared.saveContext(
                    context: context,
                    completion: completion
                )
            }
        }
    }

    //createDTOs
    public func createDTOs(
        dtos: [(any DTODescriptionBLR)],
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
